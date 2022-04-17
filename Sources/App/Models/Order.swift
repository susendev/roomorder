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
    var date: String
    
    @Field(key: "state")
    var state: OrderState

    init() { }

    init(id: UUID? = nil) {
        self.id = id
        self.state = .success
    }
    
}

struct OrderResponse: Content {

    var id: UUID?

    var userId: UUID?
    
    var userName: String?  = nil

    var roomId: UUID?
    
    var roomName: String? = nil

    var date: String
    
    var state: OrderState

    init(order: Order, joined: Bool = false) {
        self.id = order.id
        self.userId = order.$user.id
        self.roomId = order.$room.id

        if joined {
            let user = try? order.joined(User.self)
            self.userName = user?.username
            let room = try? order.joined(Room.self)
            self.roomName = room?.name
        } else {
            self.userName = nil
            self.roomName = nil
        }
        self.date = order.date
        self.state = order.state
    }
    
}
