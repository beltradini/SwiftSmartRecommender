//
//  ContentView.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var engine = RecommendationEngine()
    
    var body: some View {
        NavigationView {
            List(engine.recommendations) { rec in
                VStack(alignment: .leading) {
                    Text("ItemID: \(rec.itemID)")
                    Text("Score: \(String(format: "%.2f", rec.score))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
