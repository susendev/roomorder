//
//  User.swift
//  
//
//  Created by yigua on 2022/4/6.
//

import Fluent
import Vapor

enum Role: String, Codable  {
    case admin
    case user
}

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "role")
    var role: Role

    init() { }

    init(id: UUID? = nil, username: String, password: String, role: Role) {
        self.id = id
        self.username = username
        self.password = password
        self.role = role
    }
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
        self.role = .user
    }
    
}

extension User: Authenticatable {
    
}


struct UserResponse: Content {
    
    var id: UUID?
    
    var username: String

    var role: Role

    init(with user: User) {
        self.id = user.id
        self.username = user.username
        self.role = user.role
    }
    
}
