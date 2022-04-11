//
//  Order.swift
//  
//
//  Created by yigua on 2022/4/7.
//

import Fluent
import Vapor


enum OrderState: String, Codable  {
    case success
    case fail
    case cancel
}

final class Order: Model, Content {
    
    static let schema = "orders"
    
    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "room_id")
    var room: Room
    
    @Field(key: "scheduled_date")
    var date: Date
    
    @Field(key: "state")
    var state: OrderState

    init() { }

    init(id: UUID? = nil) {
        self.id = id
        self.state = .success
    }
    
}
