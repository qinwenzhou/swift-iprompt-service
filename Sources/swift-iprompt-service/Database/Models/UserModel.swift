//
//  UserModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct UserModel: TableCodable, Sendable {
    static var tableName: String {
        return "user"
    }
    
    var id: Int64? = nil
    var userId: Int64
    var username: String
    var gender: Int?
    var birthDate: Date?
    var phoneNumber: String?
    var email: String?
    var occupation: String?
    var memberLevel: Int
    var avatarUrl: String?
    var isSuperuser: Bool
    var createTime: Date
    var updateTime: Date
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = UserModel
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
            BindColumnConstraint(userId, isUnique: true)
        }
        
        case id
        case userId = "user_id"
        case username
        case gender
        case birthDate = "birth_date"
        case phoneNumber = "phone_number"
        case email
        case occupation
        case memberLevel = "member_level"
        case avatarUrl = "avatar_url"
        case isSuperuser = "is_superuser"
        case createTime = "create_time"
        case updateTime = "update_time"
    }
}
