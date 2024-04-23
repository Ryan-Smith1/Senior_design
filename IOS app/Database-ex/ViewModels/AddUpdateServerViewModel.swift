//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//this code was helped created by Code with Chris github tutorial https://github.com/codewithchris/YT-Vapor-iOS-App

import Foundation

final class AddUpdateServerViewModel: ObservableObject {
    @Published var systemStatus = ""
    @Published var systemPassword = ""
    var systemID: UUID?
    var isUpdateing: Bool {
        systemID != nil
    }
    
    var buttonTitle: String {
        systemID != nil ? "Update Information" : "Add information"
    }
    
    init() {}
    
    init(currentSystem: Server) {
        self.systemStatus = currentSystem.status
        self.systemPassword = currentSystem.password
        self.systemID = currentSystem.id
    }
    
    func addstatus() async throws {
        let urlString = Constants.baseUrl + Endpoints.securitystatus
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let system = Server(id: nil, status: systemStatus, password: systemPassword)
        
        try await HttpClient.shared.sendData(to: url, object: system, httpMethod: HttpMethods.POST.rawValue)
    }
    
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdateing {
                    try await updateserver()
                } else {
                    try await updateserver()
                }
            } catch {
                print("❌ Error: \(error)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func updateserver() async throws {
        let urlString = Constants.baseUrl + Endpoints.securitystatus
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        let systemToUpdate = Server(id: systemID, status: systemStatus, password: systemPassword)
        try await HttpClient.shared.sendData(to: url, object: systemToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
}

