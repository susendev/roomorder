//
//  OrderController.swift.swift
//  
//
//  Created by yigua on 2022/4/8.
//

import Foundation
import Fluent
import Vapor

struct OrderController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let orders = routes.grouped("orders")
        orders.get(use: index)
        orders.post(use: create)
        orders.group(":orderId") { item in
            item.delete(use: delete)
            item.get(use: getIndex)
        }
    }
    
    func index(req: Request) async throws -> MyResponse<[OrderResponse]> {
        let orders: [Order]
        if let user = try? req.query.get(UUID.self, at: "user") {
            orders = try await Order.query(on: req.db)
                .join(parent: \.$room)
                .join(parent: \.$user)
                .filter(\.$user.$id == user).all()
        } else {
            orders = try await Order.query(on: req.db)
                .join(parent: \.$room)
                .join(parent: \.$user)
                .all()
        }
        return MyResponse.init(data: orders.map({ OrderResponse(order: $0, joined: true) }))
    }
    
    func getIndex(req: Request) async throws -> MyResponse<OrderResponse> {
        guard let order = try await Order.find(req.parameters.get("orderId"), on: req.db) else {
            throw MyError(message: "订单查找失败", code: .orderError)
        }
        return MyResponse(data: OrderResponse(order: order))
    }
    
    func create(req: Request) async throws -> MyResponse<OrderResponse> {
        let userId = try req.content.get(UUID.self, at: "user")
        let roomId = try req.content.get(UUID.self, at: "room")
        let date = try req.content.get(String.self, at: "date")
        
        if let _ = try await Order.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$date == date)
            .first() {
            throw MyError(message: "在该日期已有预定", code: .orderError)
        }
        let order = Order()
        order.$user.id = userId
        order.$room.id = roomId
        order.date = date
        order.state = .success
        try await order.save(on: req.db)
        return MyResponse(data: OrderResponse(order: order))
    }
    
    func delete(req: Request) async throws -> NoDataResponse {
        guard let result = try await Order.find(req.parameters.get("orderId"), on: req.db) else {
            throw MyError(message: "订单查找失败", code: .orderError)
        }
        try await result.delete(on: req.db)
        return NoDataResponse()
    }
}
