//
//  UserModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct UserModel: TableCodable {
    static var tableName: String {
        return "user"
    }
    
    var id: Int
    var userId: Int
    var username: String
    var gender: Int?
    var birthDate: Date?
    var phoneNumber: String?
    var email: String?
    var occupation: String?
    var memberLevel: Int
    var avatarUrl: String?
    var isSuperuser: Bool
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = UserModel
        
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
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(id, isPrimary: true, isAutoIncrement: true)
        }
    }
}
