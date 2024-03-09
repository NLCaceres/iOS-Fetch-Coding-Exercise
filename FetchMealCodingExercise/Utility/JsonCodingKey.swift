//
//  JsonCodingKey.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/8/24.
//

import Foundation

/// Enables dynamic coding keys for easily retrieving values from KeyedDecodingContainers, typically used when manually initializing a Decodable type from a Decoder
/// This is in contrast to the typical enum-based conformance to CodingKey where only a pre-defined set of keys are allowed and expected
/// After initializing a KeyedDecodingContainer keyed by JsonCodingKey.self, all values can be retrieved via KeyedDecodingContainer.decode(_ type:, forKey: JsonCodingKey(keyName))
struct JsonCodingKey: CodingKey {
    // BOTH a string and int value are required for CodingKey conformance BUT only String keys are expected from the JSON response
    var stringValue: String
    // This initializer satisfies CodingKey's initializer requirement, even if it's not failable like in CodingKey's declaration
    init(stringValue: String) {
        self.stringValue = stringValue
    }
    
    // NOT expected to receive Int-based keys from the JSON response so it's okay to allow the initializer to fail
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
