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
    
    static func find(word: String, completion: (definition: String?) -> ()) {
        let sanitisedWord = word.lowercased().trimmingCharacters(in: CharacterSet.lowercaseLetters.inverted)
        guard let url = URL(string: "http://www.wordplays.com/definition/\(sanitisedWord)") else {
            completion(definition: nil)
            return
        }
        
        func complete(definition: String? = nil) {
            DispatchQueue.main.async {
                completion(definition: definition)
            }
        }
        
        DispatchQueue.global().async {
            guard let
                response = try? String(contentsOf: url),
                openTagRange = response.range(of: "<td class=\"defword\">"),
                closeTagRange = response.substring(from: openTagRange.upperBound).range(of: "</td>") else {
                complete()
                return
            }
            
            let definition = response
                .substring(from: openTagRange.upperBound)
                .substring(to: closeTagRange.lowerBound)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard definition.lengthOfBytes(using: .utf8) > 0 else {
                complete()
                return
            }
            
            complete(definition: definition)
        }
    }
    
}
