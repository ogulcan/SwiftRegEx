//: Playground - noun: a place where people can play

import UIKit


/***
 *  Let's start with small one
 */

let simplePattern = "run"
let simpleInput = "run forest run"

let regularExpression: NSRegularExpression = try NSRegularExpression(pattern: simplePattern, options: .caseInsensitive)
let matches = regularExpression.matches(in: simpleInput, options: [], range: NSMakeRange(0, simpleInput.utf16.count))

print(matches.count) // --> Should be 2


/***
 *  Some Swift stuff to handle crowd
 */

protocol RegexProtocol {
    var input: String? { get }
    var pattern: String? { get }
    var options: NSRegularExpression.Options { get }
    var matchingOptions: NSRegularExpression.MatchingOptions { get }
}

class Regex: RegexProtocol {
    
    typealias regexBuild = (Regex) -> Void
    
    var input: String?
    var pattern: String?
    var options: NSRegularExpression.Options = .caseInsensitive
    var matchingOptions: NSRegularExpression.MatchingOptions = []
    
    private var regularExpression: NSRegularExpression?

    init(_ build: regexBuild) throws {
        build(self)
        self.regularExpression = try NSRegularExpression(pattern: pattern!, options: options)
    }
    
    func match() -> Bool {
        guard input != nil else {
            print("Input should provided with builder")
            return false
        }
        
        return self.match(self.input!)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regularExpression?.matches(in: self.input!,
                                                 options: matchingOptions,
                                                 range: self.getRange(of: input))
        
        return (matches!.count > 0)
    }
    
    private func getRange(of text: String) -> NSRange {
        return NSMakeRange(0, text.utf16.count)
    }
}

// Example
let regEx = try Regex({
    $0.pattern = "run"
    $0.input = "run forest run"
})

regEx.match()
