//
//  CreateUser.swift
//  
//
//  Created by yigua on 2022/4/6.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await database.schema(User.schema)
            .id()
            .field("username", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .unique(on: "username")
            .create()
            
            try await User(id: nil, username: "admin", password: "admin", role: .admin).create(on: database)
            
        } catch {
            print(error)
        }
        
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}

struct CreateRoom: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            
            try await database.schema(Room.schema)
            .id()
            .field("name", .string, .required)
            .field("address", .string, .required)
            .field("seats", .int, .required)
            .field("scheduled_seats", .int, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
                        
        } catch {
            print(error)
        }
        
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}

struct CreateOrder: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await database.schema(Order.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id))
            .field("room_id", .uuid, .required, .references(Room.schema, .id))
            .field("scheduled_date", .date, .required)
            .field("state", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
        } catch {
            print(error)
        }
        
    }

    func revert(on database: Database) async throws {
        try await database.schema("todos").delete()
    }
}


