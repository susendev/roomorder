//
//  RoomController.swift
//  
//
//  Created by yigua on 2022/4/8.
//

import Foundation
import Fluent
import Vapor

struct RoomController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let rooms = routes.grouped("rooms")
        rooms.get(use: all)
        rooms.post(use: create)
        rooms.group(":roomID") { room in
            room.delete(use: delete)
            room.get(use: getIndex)
            room.put(use: put)
        }
    }

    func all(req: Request) async throws -> MyResponse<[RoomResponse]> {
        let rooms  = try await Room.query(on: req.db).all()
        return MyResponse(data: rooms.map({ RoomResponse(with: $0) }))
    }
    
    func getIndex(req: Request) async throws -> MyResponse<RoomResponse> {
        guard let room = try await Room.find(req.parameters.get("roomID"), on: req.db) else {
            throw MyError(message: "没有该教室", code: .noRoom)
        }
        return MyResponse(data: RoomResponse(with: room))
    }

    func create(req: Request) async throws -> MyResponse<RoomResponse> {
        let room = try req.content.decode(Room.self)
        if let _ = try await Room.query(on: req.db)
                .filter(\.$address == room.address)
                .first() {
                throw MyError(message: "已经存在改地址", code: .createRoom)
        }
        
        try await room.save(on: req.db)
        return MyResponse(data: RoomResponse(with: room))
    }

    func delete(req: Request) async throws -> NoDataResponse {
        guard let room = try await Room.find(req.parameters.get("roomID"), on: req.db) else {
            throw MyError(message: "没有该教室", code: .noRoom)
        }
        try await room.delete(on: req.db)
        return NoDataResponse()
    }
    
    func put(req: Request) async throws -> MyResponse<RoomResponse> {
        guard let room = try await Room.find(req.parameters.get("roomID"), on: req.db) else {
            throw MyError(message: "没有该教室", code: .noRoom)
        }
        if let name = try? req.content.get(String.self, at: "name") {
            room.name = name
        }
        if let address = try? req.content.get(String.self, at: "address") {
            room.address = address
        }
        if let seats = try? req.content.get(Int.self, at: "seats") {
            room.seats = seats
        }
        try await room.update(on: req.db)
        return MyResponse(data: RoomResponse(with: room))
    }
}
