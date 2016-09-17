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
    
    public static func find(word: String, completion: @escaping (String?) -> ()) {
        _find(word: word, completion: completion)
    }
    
    private static func _find(word: String, originalWord: String? = nil, completion: @escaping (String?) -> ()) {
        let sanitisedWord = word.lowercased().trimmingCharacters(in: CharacterSet.lowercaseLetters.inverted)
        guard let url = URL(string: "http://www.wordplays.com/definition/\(sanitisedWord)") else {
            completion(nil)
            return
        }
        
        func complete(definition: String? = nil) {
            DispatchQueue.main.async {
                guard let definition = definition else {
                    completion(nil)
                    return
                }
                if let originalWord = originalWord {
                    completion(originalWord + " or " + definition)
                } else {
                    completion(definition)
                }
            }
        }
        
        DispatchQueue.global().async {
            guard
                let response = try? String(contentsOf: url),
                let openTagIndex = response.range(of: "<td class=defword>")?.upperBound,
                let closeTagIndex = response.substring(from: openTagIndex).range(of: "</td>")?.lowerBound else {
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
            
            func hasSeeWord(prefix: String, suffix: String) -> Bool {
                if let startSeeIndex = definition.range(of: prefix)?.upperBound,
                    let endSeeIndex = definition.substring(from: startSeeIndex).range(of: suffix)?.lowerBound {
                    let referenceWord = definition
                        .substring(from: startSeeIndex)
                        .substring(to: endSeeIndex)
                    _find(word: referenceWord, originalWord: sanitisedWord, completion: completion)
                    return true
                }
                return false
            }
            
            if hasSeeWord(prefix: "<a href='/definition/", suffix: "'>") {
                return
            } else if hasSeeWord(prefix: "<a href=\"/definition/", suffix: "\">") {
                return
            }
            
            complete(definition: definition)
        }
    }
    
    
}
