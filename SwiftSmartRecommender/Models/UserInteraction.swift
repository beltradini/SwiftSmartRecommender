//
//  UserInteraction.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import Foundation

struct UserInteraction: Identifiable, Codable {
    let id: UUID
    let itemID: String
    let timestamp: Date
    let interactionType: InteractionType
}

enum InteractionType: String, Codable {
    case viewed, liked, dismissed, shared, purchased
}
