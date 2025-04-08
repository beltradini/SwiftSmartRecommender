//
//  RecommendationEngine.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import Foundation

class RecommendationEngine: ObservableObject {
  @Published var recommendations: [Recommendation] = []

  private let analyzer = PatternAnalyzer()
    private var interactions: [UserInteraction] = []
    
    func updateInteraction(_ newInteractions: [UserInteraction]) {
        interactions.append(contentsOf: newInteractions)
        generateRecommendations()
    }
    
    private func generateRecommendations() {
        let scores = analyzer.analyzeInteractions(interactions)
        recommendations = scores.map { itemID, score in
            Recommendation(id: UUID(), itemID: itemID, score: score)
        }.sorted { $0.score > $1.score }
    }
}
