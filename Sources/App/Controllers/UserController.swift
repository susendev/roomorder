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
        let users = routes.grouped("users")
        users.get(":user", use: userinfo)
        users.delete(":user", use: delete)
        users.get(use: allUsers)
        users.post(use: register)

        let user = routes.grouped("user")
        user.post("changePassword", use: changePassword)
        try user.register(collection: LoginController())
    }

    func userinfo(req: Request) async throws -> MyResponse<UserResponse> {
        guard let user = try await User.find(req.parameters.get("user"), on: req.db) else {
            throw MyError(message: "error", code: .noUser)
        }
        return MyResponse(data: UserResponse(with: user))
    }
    
    func allUsers(req: Request) async throws -> MyResponse<[UserResponse]> {
        let users  = try await User.query(on: req.db).all()
        return MyResponse(data: users.map({ UserResponse(with: $0) }))
    }

    func register(req: Request) async throws -> MyResponse<UserResponse> {
        let name: String = try req.content.get(at: "username")
        let password: String = try req.content.get(at: "password")
        let role: String = try req.content.get(at: "role")
        if let _ = try await User.query(on: req.db)
                .filter(\.$username == name)
                .first() {
                    throw MyError(message: "用户名重复", code: .registerError)
        }
        let user = User(id: nil, username: name, password: password, role: Role(rawValue: role) ?? .user)
        try await user.save(on: req.db)
        return MyResponse(data: UserResponse(with: user))
    }
    
    func delete(req: Request) async throws -> NoDataResponse {
        guard let user = try await User.find(req.parameters.get("user"), on: req.db) else {
            throw MyError(message: "没有该用户", code: .noUser)
        }
        try await user.delete(on: req.db)
        return NoDataResponse()
    }
    
    func changePassword(req: Request) async throws -> NoDataResponse {
        
        guard let id = req.headers.first(name: "id"),
              let user = try await User.find(UUID(uuidString: id), on: req.db) else {
            throw MyError(message: "没有该用户", code: .noUser)
        }
        let old: String = try req.content.get(at: "old")
        let new: String = try req.content.get(at: "new")
        if old != user.password {
            throw MyError(message: "密码错误", code: .unknow)
        }
        user.password = new
        try await user.update(on: req.db)
        return NoDataResponse()
    }

}


