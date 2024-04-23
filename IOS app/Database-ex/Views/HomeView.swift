//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import SwiftUI
import LocalAuthentication


struct HomeView: View {

    @ObservedObject var _Disarm: DisArmInfo
    @State var modal: ModalType? = nil
    @State var rotation:CGFloat = 0.0
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ArmedView(viewModel: AddUpdateServerViewModel())) {
                    ZStack {
                        Text("Security System Controls")
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
                Spacer()
                    .frame(height: 35)
                NavigationLink(destination: LockedView(_Disarm: DisArmInfo(), viewModel: AddUpdateServerViewModel())) {
                    ZStack {
                        Text("Lock the App")
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
                Spacer()
                    .frame(height: 35)
                NavigationLink(destination: ChangePassword(viewModel: AddUpdateServerViewModel())) {
                    ZStack {
                        Text("Change the password")
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
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    HomeView(_Disarm: DisArmInfo())
}

