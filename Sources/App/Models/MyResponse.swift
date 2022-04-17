//
//  MyResponse.swift
//  
//
//  Created by yigua on 2022/4/11.
//

import Vapor

struct MyResponse<T: Content>: Content {
    
    var code = 20000
    
    var message = "ok"

    let data: T
    
}

struct NoDataResponse: Content {
    
    var code = 20000
    
    var message = "ok"
    
}
