//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//this code was helped created by Code with Chris github tutorial https://github.com/codewithchris/YT-Vapor-iOS-App

import Foundation
import SwiftUI

final class ServerListViewModel: ObservableObject{
    @Published var serverinfo = [Server]()
    
    func fetchsecurity() async throws{
        let urlString = Constants.baseUrl + Endpoints.securitystatus
        
        guard let url = URL(string:urlString) else{
            throw HttpError.badURL
        }
        
        let serverResponse: [Server] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async{
            self.serverinfo = serverResponse
        }
    }
    
    func delete(at offsets: IndexSet){
        offsets.forEach{ i in
            guard let ServerID = serverinfo[i].id else{
                return
            }
            
            guard let url = URL(string:Constants.baseUrl + Endpoints.securitystatus + "/\(ServerID)")else{return}
            Task{
                do{
                    try await HttpClient.shared.delete(at: ServerID, url: url)
                }catch{
                    print("❌ error: \(error)")
                }
            }
        }
        
        
        serverinfo.remove(atOffsets: offsets) //gets rid of row from array on ios app
    }
}
