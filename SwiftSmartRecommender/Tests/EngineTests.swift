//
//  EngineTests.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import XCTest
@testable import SwiftSmartRecommender

final class EngineTests: XCTestCase {
    
    var analyzer: PatternAnalyzer!
    var testInteractions: [UserInteraction]!
    
    override func setUp() {
        super.setUp()
        analyzer = PatternAnalyzer()
        testInteractions = createTestInteractions()
    }
    
    override func tearDown() {
        analyzer = nil
        testInteractions = nil
        super.tearDown()
    }
    
    func testAnalyzerInteractions() {
        // Given
        let expectedScores: [String: Double] =  [
            "item1": 3.0,
            "item2": 0.0,
            "item3": 2.0
        ]
        
        // When
        let scores = analyzer.analyzeInteractions(testInteractions)
        
        // Then
        XCTAssertEqual(scores.count, 3)
        XCTAssertEqual(scores["item1"], expectedScores["item1"])
        XCTAssertEqual(scores["item2"], expectedScores["item2"])
        XCTAssertEqual(scores["item3"], expectedScores["item3"])
    }
    
    func testGetTopItems() {
        // Given
        let scores: [String: Double] = [
            "item1": 3.0,
            "item2": 0.0,
            "item3": 2.0,
            "item4": 5.0
        ]
        
        // When
        let topItems = analyzer.getTopItems(scores, limit: 2)
        
        // Then
        XCTAssertEqual(topItems.count, 2)
        XCTAssertEqual(topItems[0], "item4")
        XCTAssertEqual(topItems[1], "item1")
    }
    
    func testGetItemsAboveThreshold() {
        // Given
        let scores: [String: Double] = [
            "item1": 3.0,
            "item2": 0.0,
            "item3": 2.0,
            "item4": 5.0
        ]
        
        // When
        let filteredItems = analyzer.getItemsAboveThreshold(scores, threshold: 2.5)
        
        // Then
        XCTAssertEqual(filteredItems.count, 2)
        XCTAssertEqual(filteredItems["item1"], 3.0)
        XCTAssertEqual(filteredItems["item4"], 5.0)
    }
    
    func testNormalizeScores() {
            // Given
            let scores: [String: Double] = [
                "item1": 3.0,
                "item2": 0.0,
                "item3": 2.0,
                "item4": 4.0
            ]
            
            // When
            let normalized = analyzer.normalizeScores(scores)
            
            // Then
        XCTAssertEqual(normalized["item1"]!, 0.75, accuracy: 0.001)
        XCTAssertEqual(normalized["item2"]!, 0.0, accuracy: 0.001)
        XCTAssertEqual(normalized["item3"]!, 0.5, accuracy: 0.001)
        XCTAssertEqual(normalized["item4"]!, 1.0, accuracy: 0.001)
        }
        
        func testAnalyzeInteractionsWithDecay() {
            // Given
            let now = Date()
            let dayInSeconds: TimeInterval = 24 * 60 * 60
            
            let decayInteractions = [
                UserInteraction(id: UUID(), itemID: "item1", timestamp: now.addingTimeInterval(-7 * dayInSeconds), interactionType: .liked),
                UserInteraction(id: UUID(), itemID: "item1", timestamp: now, interactionType: .liked)
            ]
            
            // When
            let scores = analyzer.analyzeInteractionsWithDecay(
                decayInteractions,
                decayFactor: 0.9,
                currentDate: now
            )
            
            // Then
            // 2.0 (weight) * 0.9^7 (7 days ago) + 2.0 (recent)
            let olderWeight = 2.0 * pow(0.9, 7)
            let expectedScore = olderWeight + 2.0
            
            XCTAssertEqual(scores["item1"]!, expectedScore, accuracy: 0.001)
        }
        
        func testCustomWeights() {
            // Given
            let customWeights: [InteractionType: Double] = [
                .viewed: 0.5,
                .liked: 5.0,
                .dismissed: -2.0
            ]
            analyzer = PatternAnalyzer(weights: customWeights)
            
            // When
            let scores = analyzer.analyzeInteractions(testInteractions)
            
            // Then
            let expectedScores: [String: Double] = [
                "item1": 5.5, // 1 view (0.5) + 1 like (5.0)
                "item2": -1.5, // 1 view (0.5) + 1 dismissal (-2.0)
                "item3": 5.0  // 1 like (5.0)
            ]
            
            XCTAssertEqual(scores["item1"], expectedScores["item1"])
            XCTAssertEqual(scores["item2"], expectedScores["item2"])
            XCTAssertEqual(scores["item3"], expectedScores["item3"])
        }
        
        // Helper method to create test interactions
        private func createTestInteractions() -> [UserInteraction] {
            let now = Date()
            
            return [
                UserInteraction(id: UUID(), itemID: "item1", timestamp: now, interactionType: .viewed),
                UserInteraction(id: UUID(), itemID: "item1", timestamp: now, interactionType: .liked),
                UserInteraction(id: UUID(), itemID: "item2", timestamp: now, interactionType: .viewed),
                UserInteraction(id: UUID(), itemID: "item2", timestamp: now, interactionType: .dismissed),
                UserInteraction(id: UUID(), itemID: "item3", timestamp: now, interactionType: .liked)
            ]
        }
}
