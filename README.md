# SwiftSmartRecommender

A Swift-based recommendation engine that analyzes user interactions to generate personalized recommendations.

## Features

- Pattern analysis of user interactions (views, likes, dismissals)
- Score weighting and normalization
- Time decay analysis for more recent interactions
- SwiftUI interface for displaying recommendations
- Filtering recommendations by score threshold

## Components

### Pattern Analysis

The `PatternAnalyzer` class processes user interactions and calculates recommendation scores:

- `analyzeInteractions()` - Calculate basic recommendation scores
- `analyzeInteractionsWithDecay()` - Apply time-based decay to older interactions
- `normalizeScores()` - Normalize scores between 0 and 1
- `getTopItems()` - Get a ranked list of top recommendations
- `getItemsAboveThreshold()` - Filter items that meet score criteria

### User Interface

The project includes SwiftUI views for displaying recommendations:

- `RecommendationDashboard` - Main container with tabs
- `RecommendationListView` - Displays ranked recommendations
- `ScoreIndicator` - Visual component showing recommendation strength
- `RecommendationFilters` - UI for adjusting filtering parameters

## Usage

Initialize the analyzer and process user interactions:

```swift
let analyzer = PatternAnalyzer()
let scores = analyzer.analyzeInteractions(userInteractions)
let recommendations = analyzer.getTopItems(scores, limit: 10)
```

Display the recommendations using the SwiftUI components:

```swift
RecommendationDashboard()
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.5+
- Xcode 13.0+

## License

This project is available under the MIT license.
