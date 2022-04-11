//
//  UserController.swift
//  
//
//  Created by yigua on 2022/4/8.
//

import Foundation
import Fluent
import Vapor

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        users.get(":user", use: userinfo)
        try users.register(collection: LoginController())
    }

    func userinfo(req: Request) async throws -> MyResponse<UserResponse> {
        guard let user = try await User.find(req.parameters.get("user"), on: req.db) else {
            throw Abort(.notFound)
        }
        return MyResponse(data: UserResponse(with: user))
    }

}


