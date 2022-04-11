//
//  migrations.swift
//  
//
//  Created by yigua on 2022/4/10.
//

import Vapor

func migrations(_ app: Application) throws {

    app.migrations.add(CreateUser())
    app.migrations.add(CreateRoom())
    app.migrations.add(CreateOrder())
    
}
