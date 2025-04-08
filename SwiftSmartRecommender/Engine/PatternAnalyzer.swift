//
//  PatternAnalyzer.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import Foundation

class PatternAnalyzer {
    private var weights: [InteractionType: Double]
    let defaultDecayFactor: Double = 0.9
    
    init(weights: [InteractionType: Double]? = nil) {
        self.weights = weights ?? [
            .viewed: 1.0,
            .liked: 2.0,
            .dismissed: -1.0,
            .shared: 3.0,
            .purchased: 5.0
        ]
    }
    
    // Basic analysis without time decay
    func analyzeInteractions(_ interactions: [UserInteraction]) -> [String: Double] {
        var scores: [String: Double] = [:]
        
        for interaction in interactions {
            if let weight = weights[interaction.interactionType] {
                scores[interaction.itemID, default: 0] += weight
            }
        }
        
        return scores
    }
    
    // Enhanced analysis with time decay
    func analyzeInteractionsWithDecay(_ interactions: [UserInteraction], decayFactor: Double? = nil, currentDate: Date = Date()) -> [String: Double] {
        var scores: [String: Double] = [:]
        let decay = decayFactor ?? defaultDecayFactor
        
        for interaction in interactions {
            let daysSinceInteraction = calculateDaysBetween(interaction.timestamp, and: currentDate)
            let weight = weights[interaction.interactionType] ?? 0.0
            
            // Apply exponential decay: weigth * decay-days
            let adjustedWeight = weight * pow(decay, Double(daysSinceInteraction))
            
            scores[interaction.itemID] = (scores[interaction.itemID] ?? 0) + adjustedWeight
        }
        
        return scores
    }
    
    // Helper function to calculate days between two dates
    private func calculateDaysBetween(_ date1: Date, and date2: Date) -> Double {
        let timeInterval = date2.timeIntervalSince(date1)
        let dayInSeconds: TimeInterval = 24 * 60 * 60
        return timeInterval / dayInSeconds
    }
}

// Get top N items sorted by score
extension PatternAnalyzer {
    func getTopItems(_ scores: [String: Double], limit: Int = 10) -> [String] {
        return scores.sorted { $0.value > $1.value }
            .prefix(limit)
            .map { $0.key }
    }
    
    // Filter items by threshold 
    func getItemsAboveThreshold(_ scores: [String: Double], threshold: Double) -> [String: Double] {
        return scores.filter { $0.value >= threshold }
    }
}

extension PatternAnalyzer {
    func normalizeScores(_ scores: [String: Double]) -> [String: Double] {
        guard !scores.isEmpty else { return [:] }
        
        let maxScore = scores.values.max() ?? 1.0
        let minScore = scores.values.min() ?? 0.0
        let range = maxScore - minScore
        
        if range == 0 { return scores.mapValues { _ in 0.5 } }
        
        return scores.mapValues { ($0 - minScore) / range }
    }
}

extension PatternAnalyzer {
    func analyzeInteractionsWithDecay(_ interactions: [UserInteraction],
                                      decayFactor: Double = 0.9,
                                      currentDate: Date = Date()) -> [String: Double] {
        var scores: [String: Double] = [:]
        
        let sortedInteractions = interactions.sorted { $0.timestamp < $1.timestamp }
        
        for interaction in sortedInteractions {
            if let weight = weights[interaction.interactionType] {
                let daysAgo = currentDate.timeIntervalSince(interaction.timestamp) / (24 * 3600)
                let adjustedWeight = weight * pow(decayFactor, daysAgo)
                scores[interaction.itemID, default: 0] += adjustedWeight
            }
        }
        
        return scores
    }
}
