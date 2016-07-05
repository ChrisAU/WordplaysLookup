//
//  WordplaysLookup.swift
//  WordplaysLookup
//
//  Created by Chris Nevin on 5/07/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//
//  This is essentially a html scraper for the 'wordplays.com' website
//  which get the first definition of a given word and returns the value.

import Foundation

public enum WordplaysLookup {
    
    public static func find(word: String, completion: (definition: String?) -> ()) {
        _find(word: word, completion: completion)
    }
    
    private static func _find(word: String, originalWord: String? = nil, completion: (definition: String?) -> ()) {
        let sanitisedWord = word.lowercased().trimmingCharacters(in: CharacterSet.lowercaseLetters.inverted)
        guard let url = URL(string: "http://www.wordplays.com/definition/\(sanitisedWord)") else {
            completion(definition: nil)
            return
        }
        
        func complete(definition: String? = nil) {
            DispatchQueue.main.async {
                guard let definition = definition else {
                    completion(definition: nil)
                    return
                }
                if let originalWord = originalWord {
                    completion(definition: originalWord + " or " + definition)
                } else {
                    completion(definition: definition)
                }
            }
        }
        
        DispatchQueue.global().async {
            guard let
                response = try? String(contentsOf: url),
                openTagIndex = response.range(of: "<td class=defword>")?.upperBound,
                closeTagIndex = response.substring(from: openTagIndex).range(of: "</td>")?.lowerBound else {
                    complete()
                    return
            }
            
            let definition = response
                .substring(from: openTagIndex)
                .substring(to: closeTagIndex)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard definition.lengthOfBytes(using: .utf8) > 0 else {
                complete()
                return
            }
            
            if let startSeeIndex = definition.range(of: "<a href='/definition/")?.upperBound, endSeeIndex = definition.substring(from: startSeeIndex).range(of: "'>")?.lowerBound {
                let referenceWord = definition
                    .substring(from: startSeeIndex)
                    .substring(to: endSeeIndex)
                _find(word: referenceWord, originalWord: sanitisedWord, completion: completion)
                return
            }
            
            complete(definition: definition)
        }
    }
    
}
