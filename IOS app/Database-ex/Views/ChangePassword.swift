//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI

struct ChangePassword: View {
    @ObservedObject var viewModel: AddUpdateServerViewModel
    @StateObject var fetchModel = ServerListViewModel()
    //@Environment(\.presentationMode) var presentationMode
    @State private var isPasswordUpdated = "Update"
    @State private var newPassword = ""
    @State private var HashedPassword = ""
    @State private var doubletap = false
    var body: some View {
        Spacer()
        HStack{
            TextField("New Password",text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray,lineWidth: 2)
                )
                .frame(width: 300)
            Button{
                let HashedPassword = polynomialHash(newPassword)
                if let firstrow = fetchModel.serverinfo.first{
                    viewModel.addUpdateAction {viewModel.systemPassword = String(HashedPassword); viewModel.systemStatus = firstrow.status; viewModel.systemID = UUID(uuidString: "4fe97919-ea4d-4246-b05c-a2871298e285")
                        isPasswordUpdated = "Confirm"}}
                
            }label:{
                Text(isPasswordUpdated)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue,lineWidth: 2)
                        .frame(width: 100,height: 34)
                    )
                    .font(.system(size: 25))
                    .frame(width: 100)
            }
        }
        Spacer()
            .frame(height: 10)
        .onAppear(perform: {
            fetchserver()
        })
    }
    func fetchserver() {
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
    ChangePassword(viewModel: AddUpdateServerViewModel())
}
