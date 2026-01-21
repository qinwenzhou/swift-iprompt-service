//
//  HTTPStatusCode.swift
//  swift-iprompt-service
//
//  Created by david on 2026/1/20.
//

public enum HTTPStatusCode: Int {
    case success = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
}
