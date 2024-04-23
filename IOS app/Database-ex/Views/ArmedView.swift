//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI



 

struct ArmedView: View {
    @Environment(\.dismiss) private var dismiss
    @State var rotation:CGFloat = 0.0
    @ObservedObject var viewModel: AddUpdateServerViewModel
    @StateObject var fetchModel = ServerListViewModel()
    //@Environment(\.presentationMode) var presentationMode
    @State private var errorcatch = 0
    @State private var isSystemArmed = false
    var body: some View {
        VStack{
            //isSystemArmed = (viewModel.songTitle == "Arm")? true:false
            //let disarmText = isSystemArmed ? "The System is Armed" : "The System is Disarmed"
            Button{
                if let firstrow = fetchModel.serverinfo.first{
                    if(viewModel.systemStatus == "Disarm"){isSystemArmed = false}
                    else{isSystemArmed = true}
                    if(viewModel.systemStatus == "Disarm"){viewModel.systemStatus = "Arm";viewModel.systemPassword = firstrow.password; viewModel.systemID = UUID(uuidString: "4fe97919-ea4d-4246-b05c-a2871298e285")}
                    else {viewModel.systemStatus = "Disarm";viewModel.systemPassword = firstrow.password; viewModel.systemID = UUID(uuidString: "4fe97919-ea4d-4246-b05c-a2871298e285")}
                    fetchStatus()
                    viewModel.addUpdateAction {/*presentationMode.wrappedValue.dismiss();*/fetchStatus()}}
            }label:{
                if(errorcatch == 1){Text("Error Connecting to Server")}
                else if let firstrow = fetchModel.serverinfo.first{
                    ZStack {
                        Text("The System is \(firstrow.status)ed")
                            .frame(width: 345, height: 40)
                            .padding(.vertical, 20)
                            .background(.ultraThinMaterial)
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                            .font(.system(size: 25))
                            .font(Font.headline.weight(.bold))
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(width: 400, height: 400)
                            .frame(width: 400, height: 60)
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red, .orange, .pink, .purple, .blue]), startPoint: .leading, endPoint: .trailing))
                            .rotationEffect(.degrees(rotation))
                            .mask {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(lineWidth: 7.5)
                                    .frame(width: 345, height: 70)
                            }
                    }
                    .onAppear {
                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }
                }
            }
        }
        .onAppear{
            fetchStatus()
        }
    }
    func fetchStatus() {
        Task {
            do {
                try await fetchModel.fetchsecurity()
                errorcatch = 0
            } catch {
                print("Error fetching status: \(error)")
                errorcatch = 1
            }
        }
    }
}

#Preview {
    ArmedView(viewModel: AddUpdateServerViewModel())
}

