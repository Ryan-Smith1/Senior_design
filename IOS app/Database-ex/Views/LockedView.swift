//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI
import LocalAuthentication


struct LockedView: View {
    @State private var name = "0000"
    @State private var HashedPassword = "0000"
    @State private var LockText = "LOCKED"
    @State private var isUnlocked = false
    @State private var isInVisible = false
    @State private var isPasswordWanted = false
    @State private var password: String = ""
    @State private var passwordtext = "Use Password to unlock"
    @State private var shouldNavigate = false
    @ObservedObject var _Disarm: DisArmInfo
    @ObservedObject var viewModel: AddUpdateServerViewModel
    @StateObject var fetchModel = ServerListViewModel()
    var body: some View {
        Spacer()
            .navigationBarBackButtonHidden(true)
            if(isPasswordWanted){
            Spacer()
                .frame(height: 100)}
        if !_Disarm.LockStatus{
            Button{isPasswordWanted.toggle();
                //if ap is unlocked hid the button
                if _Disarm.LockStatus == true {isInVisible.toggle()}
                passwordtext = isPasswordWanted ? "Exit Password Login" : "Use Password to unlock"}
            label:{
                Text(passwordtext)
                    .frame(width: 275,height: 25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .font(.system(size: 25))
                    .font(Font.headline.weight(.bold))
            }
                Spacer()
                    .frame(height: 35)
            if(!isPasswordWanted){
                Button{authenticate();
                    //if app is unlocked hide the button
                    if _Disarm.LockStatus == true {isInVisible.toggle()}
                }
            label:{
                Text("Use Biometrics to unlock")
                    .frame(width: 275,height: 25)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .font(.system(size: 25))
                .font(Font.headline.weight(.bold))}
                Spacer()
                .frame(height: 300)}
        }
        if(!isPasswordWanted && isUnlocked){
            Spacer()
                .frame(height: 300)
        }
        if(isPasswordWanted){
            HStack{
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray,lineWidth: 2))
                Button{
                    if let firstrow = fetchModel.serverinfo.first{
                        print(firstrow.password)
                        let HashedPassword = polynomialHash(password)
                        if (firstrow.password == String(HashedPassword)){
                            _Disarm.LockStatus = true;
                            isPasswordWanted = false;
                            isInVisible.toggle();
                            LockText = "UNLOCKED";}
                        else{password = "Incorrect password try again"}
                    }
                }label:{
                    Text("Enter")
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue,lineWidth: 2)
                            .frame(width: 70,height: 34)
                        )
                        .font(.system(size: 25))
                        .frame(width: 75)
                }
            }
            .onAppear{
                fetchdata()
            }
            .padding(5)

            .padding()
            .keyboardType(.webSearch)
            .autocorrectionDisabled(true)
        }
        if _Disarm.LockStatus {
            NavigationView {
                NavigationLink(destination: HomeView(_Disarm: DisArmInfo())) {
                    Text("Enter the app")
                        .frame(width: 275,height: 25)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .font(.system(size: 25))
                        .font(Font.headline.weight(.bold))
                }
            }
        }
    }
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Want to be secure? Use Face ID"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {LockText = "UNLOCKED";_Disarm.LockStatus = true;isInVisible = true}//passed biametrics
                else { LockText = "There was a problem try another way"; _Disarm.LockStatus = false;isInVisible = false}//failed biometrics
            }
        }
        else { LockText = "Phone does not support Biometric authentication"}//no biametrics
    }
    func fetchdata() {
        Task {
            do {
                try await fetchModel.fetchsecurity()
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    func polynomialHash(_ text: String) -> Int {
        var hashValue = 0
        let prime = 31
        let modulus = 1_000_000_009

        for char in text.unicodeScalars {
            let charValue = Int(char.value)
            hashValue = (hashValue &* prime &+ charValue) % modulus
        }

        return hashValue
    }
}

#Preview {
    LockedView(_Disarm: DisArmInfo(), viewModel: AddUpdateServerViewModel())
}
