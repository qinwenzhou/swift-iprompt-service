//
//  UserModel.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
@preconcurrency import WCDBSwift

internal struct UserModel: DBModel {
    static var tableName: String {
        return "user"
    }
    
    var identifier: UInt64? = nil
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
        
        static let objectRelationalMapping = TableBinding(CodingKeys.self) {
            BindColumnConstraint(identifier, isPrimary: true, isAutoIncrement: true)
        }
        
        case identifier
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
    }
}

extension UserModel {
    static func getAllObjects() throws -> [Self] {
        return try database.getObjects(fromTable: Self.tableName)
    }
}
