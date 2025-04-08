//
//  DataScore.swift
//  SwiftSmartRecommender
//
//  Created by Alejandro Beltrán on 4/6/25.
//

import Foundation

class DataScore {
    static let shared = DataScore()
    private let filename = "interactions.json"
    
    func save(_ interactions: [UserInteraction]) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        if let data = try? JSONEncoder().encode(interactions) {
            try? data.write(to: url)
        }
    }
    
    func load() -> [UserInteraction] {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return [] }
                return (try? JSONDecoder().decode([UserInteraction].self, from: data)) ?? []
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
