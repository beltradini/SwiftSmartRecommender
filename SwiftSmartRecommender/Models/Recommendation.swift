//
//  Recommendation.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import Foundation

struct Recommendation: Identifiable, Codable {
    let id: UUID
    let itemID: String
    let score: Double
}
