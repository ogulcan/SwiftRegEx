//: Playground - noun: a place where people can play

import UIKit


/***
 *  Let's start with small one
 */

let simplePattern = "run"
let simpleInput = "run forest run"

let regularExpression: NSRegularExpression = try NSRegularExpression(pattern: simplePattern, options: .caseInsensitive)
let matches = regularExpression.matches(in: simpleInput, options: [], range: NSMakeRange(0, simpleInput.utf16.count))

matches.count // --> Should be 2


/***
 *  # Wrapper
 *
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
    var options: NSRegularExpression.Options = .anchorsMatchLines
    var matchingOptions: NSRegularExpression.MatchingOptions = []
    
    private var regularExpression: NSRegularExpression?
    private var checkingResult: [NSTextCheckingResult]?

    init(_ build: regexBuild) throws {
        build(self)
        self.regularExpression = try NSRegularExpression(pattern: pattern!, options: options)
    }
    
    func matches() -> Bool {
        guard input != nil else {
            print("Input should provided with builder")
            return false
        }
        
        return self.matches(self.input!)
    }
    
    func matches(_ input: String) -> Bool {
        self.checkingResult = regularExpression?.matches(in: self.input!,
                                                         options: matchingOptions,
                                                         range: self.getRange(of: input))
        
        return (self.checkingResult!.count > 0)
    }
    
    func match() -> (Bool, Int) {
        guard input != nil else {
            print("Input should provided with builder")
            return (false, 0)
        }
        
        return (self.matches(self.input!), self.checkingResult!.count)
    }
    
    func match(_ input: String) -> (Bool, Int) {
        return (self.matches(input), self.checkingResult!.count)
    }
    
    private func getRange(of text: String) -> NSRange {
        return NSMakeRange(0, text.count) // Swift 4 will let call just count
    }
}

// Example
var regEx = try Regex({
    $0.pattern = "run"
    $0.input = "run forest run"
})

regEx.matches() // --> Should be true
regEx.match().1 // --> Should be 2

regEx = try Regex({
    $0.pattern = "run"
    $0.input = "Run forest run"
})

regEx.matches() // --> Should be true
regEx.match().1 // --> Should be 1 (Because pattern is case sensitive as declared above by options)

/***
 *  # Meta Characters
 *
 *  Note: All descriptions are from learn-regex repository that created by Zeeshan Ahmed
 *  https://github.com/zeeshanu/learn-regex
 */

/// . (period character): "Period matches any single character except a line break."

// Example
regEx = try Regex({
    $0.pattern = ".ies"
    $0.input = "All cities are filled with puppies"
})

regEx.match().0 // --> Should be true
regEx.match().1 // --> Should be 2

// Example
regEx = try Regex({
    $0.pattern = "ies."
    $0.input = "All cities are filled with puppies"
})

regEx.match().0 // --> Should be true
regEx.match().1 // --> Should be 1 (Because . 'puppies' is not matched with any character that follows by 'ies')

/// [] (character set): "Matches any character contained between the square brackets."

// Example
regEx = try Regex({
    $0.pattern = "[Rr]un"
    $0.input = "Run forest run"
})

regEx.match().0 // --> Should be true
regEx.match().1 // --> Should be 2 (Now it matches with both cases)

// Example
regEx = try Regex({
    $0.pattern = "ies[.]"
    $0.input = "All cities are filled with puppies."
})

regEx.match().0 // --> Should be true
regEx.match().1 // --> Should be 1 (Because period character is inside bracket)

/// [^] (negated character set): "Matches any character that is not contained between the square brackets"

// Example
regEx = try Regex({
    $0.pattern = "[^t]ies"
    $0.input = "All cities are filled with puppies."
})

regEx.match() // --> Should be true & 1

/// + (repetitions character): "The symbol + matches one or more repetitions of the preceding character"

// Example
regEx = try Regex({
    $0.pattern = "c.+t"
    $0.input = "The fat cat sat on the mat."
})

regEx.match() // --> Should be true & 1 (It's just one match, because pattern does not look for repetitions)

/// * (repetitions character): "The symbol * matches zero or more repetitions of the preceding matcher"

// Example
regEx = try Regex({
    $0.pattern = "c.+t"
    $0.input = "The fat cat sat on the mat."
})

regEx.match() // --> Should be true & 1 (It's just one match, because pattern does not look for repetitions)

/// ? (repetitions character): "Meta character ? makes the preceding character optional"

