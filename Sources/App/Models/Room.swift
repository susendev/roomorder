//
//  Room.swift
//  
//
//  Created by yigua on 2022/4/6.
//

import Fluent
import Vapor

final class Room: Model, Content {
    
    static let schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    @Field(key: "name")
    var name: String
    
    @Field(key: "address")
    var address: String
    
    @Field(key: "seats")
    var seats: Int
    
    @Field(key: "scheduled_seats")
    var scheduledSeats: Int
    
    var unScheduledSeats: Int {
        return seats - scheduledSeats
    }

    init() { }

    init(id: UUID? = nil, name: String, address: String, seats: Int) {
        self.id = id
        self.name = name
        self.address = address
        self.seats = seats
        self.scheduledSeats = 0
    }
    
}
