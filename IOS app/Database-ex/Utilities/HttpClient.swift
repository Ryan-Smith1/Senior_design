//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//this code was helped created by Code with Chris github tutorial https://github.com/codewithchris/YT-Vapor-iOS-App

import Foundation

enum HttpMethods: String{
    case POST, GET, PUT, DELETE
}

enum MIMEType: String{
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error{
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HttpClient{
    private init(){}
    
    static let shared = HttpClient()
    
    func fetch<T: Codable> (url:URL) async throws -> [T]{
        let (data, response) = try await URLSession.shared.data(from: url)
        guard(response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        guard let object = try? JSONDecoder().decode([T].self, from:data) else{
            throw HttpError.errorDecodingData
        }
        return object
    }
    
    func sendData<T: Codable> (to url:URL, object: T, httpMethod: String)async throws{
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.httpBody = try? JSONEncoder().encode(object)
        
        let (_,response) = try await URLSession.shared.data(for:request)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
    }
    
    func delete(at id: UUID, url:URL) async throws{
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.DELETE.rawValue
        
        let (_,response) = try await URLSession.shared.data(for: request)
        
        guard(response as? HTTPURLResponse)?.statusCode == 200 else{
            throw HttpError.badResponse
        }
    }
}
