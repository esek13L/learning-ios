//
//  APIResponse.swift
//  networking
//
//  Created by Esekiel Surbakti on 14/06/21.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let data: T?
    let error: String?
}
