//copyright (c) 2024 Ryan Smith
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//this code was helped created by Code with Chris github tutorial https://github.com/codewithchris/YT-Vapor-API

import Fluent
import Vapor

struct SecurityController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let securitystatus = routes.grouped("securitystatus")
        securitystatus.get(use: index)
        securitystatus.post(use: create)
        securitystatus.put(use: update)
        securitystatus.group(":securitystatusID") { securitystatus in
            securitystatus.delete(use: delete)
        }
    }
    
    
    func index(req: Request) async throws -> [SecurityStatus] {
        try await SecurityStatus.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus {
        let securitystatus = try req.content.decode(SecurityStatus.self)
        
        try await securitystatus.save(on: req.db)
        return .ok
    }
    
    func update(req: Request) async throws -> HTTPStatus {
        let securitystatus = try req.content.decode(SecurityStatus.self)
        guard let InfoFromDB = try await SecurityStatus.find(securitystatus.id, on: req.db) else {
            throw Abort(.notFound)
        }
        InfoFromDB.password = securitystatus.password
        InfoFromDB.status = securitystatus.status
        try await InfoFromDB.update(on: req.db)
        return .ok
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        guard let securitystatus = try await SecurityStatus.find(req.parameters.get("securitystatusID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await securitystatus.delete(on: req.db)
        return .ok
    }
}
