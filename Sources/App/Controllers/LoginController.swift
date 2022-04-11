//
//  LoginController.swift
//  
//
//  Created by yigua on 2022/4/8.
//

import Foundation
import Fluent
import Vapor

struct LoginController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("login", use: login)
        routes.post("register", use: register)
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let todo = try await Todo.find(req.parameters.get("todoID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await todo.delete(on: req.db)
        return .ok
    }
    
    func login(req: Request) async throws -> MyResponse<UserResponse> {
        let name: String = try req.content.get(at: "username")
        let password: String = try req.content.get(at: "password")
        guard let user = try await User.query(on: req.db)
                .filter(\.$username == name)
                .filter(\.$password == password)
                .first() else {
                    throw MyError(message: "登录验证失败", code: .loginError)
        }
        return MyResponse(data: UserResponse(with: user))
    }
    
    func register(req: Request) async throws -> MyResponse<UserResponse> {
        let name: String = try req.content.get(at: "username")
        let password: String = try req.content.get(at: "password")
        if let _ = try await User.query(on: req.db)
                .filter(\.$username == name)
                .first() {
                    throw MyError(message: "用户名重复", code: .registerError)
        }
        let user = User(id: nil, username: name, password: password, role: .user)
        try await user.save(on: req.db)
        return MyResponse(data: UserResponse(with: user))
    }
    
}
