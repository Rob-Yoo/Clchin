//
//  LoginRequest.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/20/24.
//

import Foundation

struct LoginBodyDTO: Encodable {
    let email: String
    let password: String
}
