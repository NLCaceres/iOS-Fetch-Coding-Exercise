#  Coding Exercise for the Fetch Rewards iOS Team

- App renders a list of Desserts from The Meal DB, and by clicking any Dessert from the list, it takes you to a detailed view of the Dessert, 
its ingredients and numbered instructions.
- Written using SwiftUI and a MVVM Architecture, splitting various features, like the API Service, into their own files outside of the Model, View and ViewModel

## Features
- Makes requests to The Meal DB's following two endpoints:
    - Lookup by ID to grab individual Dessert Meals
    - Filter by Category to grab a list of Meals in that category, in particular for this app, Desserts, sorting them by name
- Splits the Meal objects received from The Meal DB into 3 immutable structs, the parent Meal struct, and its two children, Ingredient and Instructions.
    - Since the Meal JSON objects received are relatively flat structured, the parent Meal overrides the Decodable protocol's initializer to properly parse the JSON into Meal objects
        - Uses a combination of static Coding Keys to grab the expected keys from the Meal object as well as a struct-based Coding Key for dynamically grabbing numbered Ingredient keys
    - Both Ingredient and Instructions set additional properties on initialization based on their properties in The Meal DB. This is done instead of creating computed properties which
    re-run every time they are requested, leading to potentially expensive re-calculations
- Testable thanks to separation of concerns, extracting out features like the API Service into its own file and injecting these concerns ONLY where they are needed via initializer
    - By enabling dependency injection, Mocks are easily substituted into tests, so that extra requests to the DB or time-consuming operations can be limited, focusing purely
    on the subject under any given test.

### Notes on Xcode Limitation
- My MacBook Pro is limited to Xcode 14.2 due to age, so minimum deployment version is 16.2 instead of latest but should be compilable to latest.
