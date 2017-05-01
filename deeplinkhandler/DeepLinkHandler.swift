//
//  DeepLinkHandler.swift
//  deeplinkhandler
//
//  Created by Sahil Dudeja on 5/1/17.
//
//

import Foundation

typealias DeepLinkPattern = String
typealias DeepLinkClosure = (DeepLinkParams) -> Bool

extension DeepLinkPattern {
    
    func captureGroups(regex: NSRegularExpression) -> [String]? {
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
        guard let match = matches.first else { return nil }
        
        // Note: Index 1 is 1st capture group, 2 is 2nd, ..., while index 0 is full match which we don't use
        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return nil }
        
        var results = [String]()
        
        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.rangeAt(i)
            let matchedString = (self as NSString).substring(with: capturedGroupIndex)
            results.append(matchedString)
        }
        
        return results
    }
    
    func pathToPatternRegexBuilder(paramPattern: String, withPattern: String) -> NSRegularExpression? {
        do {
            let pattern = self.replacingOccurrences(of: paramPattern,
                                                    with: withPattern,
                                                    options: .regularExpression,
                                                    range: self.startIndex..<self.endIndex)
            
            return try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return nil
        }
        
    }
    
}

struct DeepLinkEntry {
    
    static let PARAM_PATTERN = "\\{([^}]+)\\}"
    static let PARAM = "([a-zA-Z][a-zA-Z0-9_-]*)"
    static let PARAM_VALUE = "([a-zA-Z0-9_#'!+%~,\\-\\.\\@\\$\\:]+)"
    let pattern: DeepLinkPattern
    let closure: DeepLinkClosure
    let computedRegex: NSRegularExpression
    let predicate: NSPredicate
    
    public init(pattern: DeepLinkPattern, closure: @escaping DeepLinkClosure) {
        self.pattern = pattern
        self.closure = closure
        self.computedRegex = pattern.pathToPatternRegexBuilder(paramPattern: DeepLinkEntry.PARAM_PATTERN,
                                                               withPattern: DeepLinkEntry.PARAM_VALUE)!
        self.predicate = NSPredicate(format:"SELF MATCHES %@", self.computedRegex.pattern)
    }
    
    public func isMatchingWithPattern(url: String) -> Bool {
        return predicate.evaluate(with:url)
    }
    
    public func openScreen(url: String, queryItems: [URLQueryItem]?) -> Bool {
        var params = DeepLinkParams(url: url)
        extractParams(deepLinkParams: &params, queryItems: queryItems)
        return closure(params)
    }
    
    func extractParams( deepLinkParams: inout DeepLinkParams, queryItems: [URLQueryItem]?) {
        let urlParams: [String]? = pattern.replacingOccurrences(of: "[\\{\\}]", with: "", options: .regularExpression, range: nil)
            .captureGroups(regex: computedRegex)
        if urlParams != nil {
            let length = urlParams!.count
            let values = fetchParamValues(url:deepLinkParams.url)
            for index in 0..<length {
                deepLinkParams.queryItems[urlParams![index]] = values[index].removingPercentEncoding
            }
        }
        if queryItems != nil {
            for item in queryItems! {
                if item.value != nil {
                    deepLinkParams.queryItems[item.name] = item.value!.removingPercentEncoding
                }
            }
        }
    }
    
    func fetchParamValues(url: String) -> [String] {
        return url.captureGroups(regex: computedRegex)!
    }
    
}

struct DeepLinkParams {
    let url: String
    var queryItems: [String:String] = [:]
    
    init (url: String) {
        self.url = url
    }
}

protocol DeepLinkAnalyzerProtocol{
    var registry: [DeepLinkEntry] {get}
    func parseURL(url: URL) -> Bool
}
