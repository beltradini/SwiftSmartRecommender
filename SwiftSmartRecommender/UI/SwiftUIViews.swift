//
//  SwiftUIViews.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import SwiftUI

struct RecommendationListView: View {
    let recommendations: [String]
    let scores: [String: Double]
    
    var body: some View {
        List {
            ForEach(recommendations, id: \.self) { itemID in
                RecommendationRow(itemID: itemID, score: scores[itemID] ?? 0.0)
            }
        }
        .navigationTitle("Recommendations")
    }
}

struct RecommendationRow: View {
    let itemID: String
    let score: Double
    
    var body: some View {
        HStack {
            Text(itemID)
                .font(.headline)
            Spacer()
            ScoreIndicator(score: score)
        }
        padding(.vertical, 8)
    }
}

struct ScoreIndicator: View {
    let score: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(scoreColor, lineWidth: 3)
                .frame(width: 40, height: 40)
            Text(String(format: "%.1f", score))
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(scoreColor)
        }
    }
    
    private var scoreColor: Color {
        if score >= 3.0 {
            return .green
        } else if score >= 0 {
            return .blue
        } else {
            return .red
        }
    }
}

struct RecommendationDashboard: View {
    @StateObject private var viewModel = RecommendationViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecommendationListView(
                recommendations: viewModel.topRecommendations, scores: viewModel.scores
            )
            .tabItem {
                Label("Top Picks", systemImage: "star.fill")
            }
            .tag(0)
            
            RecommendationFilters(viewModel: viewModel)
                .tabItem {
                    Label("Filters", systemImage: "slider.horizontal.3")
                }
            tag(1)
        }
        .onAppear {
            viewModel.loadRecommendations()
        }
    }
}

struct RecommendationFilters: View {
    @ObservedObject var viewModel: RecommendationViewModel
    
    var body: some View {
        Form {
            Section("Filter Options") {
                Slider(value: $viewModel.scoreThreshold, in: -5...5, step: 0.5) {
                    Text("Minimum Score: \(viewModel.scoreThreshold, specifier: "%.1f")")
                }
                
                Stepper("Max Results: \(viewModel.maxResults)", value: $viewModel.maxResults, in: 5...50, step: 5)
            }
            
            Button("Apply Filters") {
                viewModel.applyFilters()
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("Recommendation Filters")
    }
}

class RecommendationViewModel: ObservableObject {
    @Published var scores: [String: Double] = [:]
    @Published var topRecommendations: [String] = []
    @Published var scoreThreshold: Double = 0.0
    @Published var maxResults: Int = 20
    
    private let analyzer = PatternAnalyzer()
    
    func loadRecommendations() {
        // In a real app, this would fetch interactions from a database
        let mockInteractions = createMockInteractions()
        scores = analyzer.analyzeInteractions(mockInteractions)
        applyFilters()
    }
    
    func applyFilters() {
        topRecommendations = scores
            .filter { $0.value >= scoreThreshold }
            .sorted { $0.value > $1.value }
            .prefix(maxResults)
            .map { $0.key }
    }
    
    private func createMockInteractions() -> [UserInteraction] {
        // Create sample data for testing
        var interactions: [UserInteraction] = []
        
        let items = ["item1", "item2", "item3", "item4", "item5"]
        let types: [InteractionType] = [.viewed, .liked, .dismissed]
        
        for _ in 1...30 {
            let itemID = items.randomElement()!
            let type = types.randomElement()!
            let timestamp = Date().addingTimeInterval(-Double.random(in: 0...(86400 * 7)))
            
            interactions.append(UserInteraction(id: UUID(), itemID: itemID, timestamp: timestamp, interactionType: type))
        }
        
        return interactions
    }
}

struct ContentPreview: PreviewProvider {
    static var previews: some View {
        RecommendationDashboard()
    }
}
