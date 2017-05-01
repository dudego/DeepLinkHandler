# DeepLinkHandler - Swift
Handle iOS Universal/DeepLinks in a better way

DeepLink handler is a custom scheme/ URL handling helper to free you from worries for matching URL and extracting parameters. 

### Implementation 

1. Copy `DeepLinkHandler` to your project
2. Implement `DeepLinkAnalyzerProtocol` (Provide URL and Closure)
3. Check `DeepLinkAnalyzer().parseURL(url: url)`
4. Done :)

All parameters and Values are provided in `DeepLinkClosure` as `DeepLinkParams`

### Example
```swift
class DeepLinkAnalyzer: DeepLinkAnalyzerProtocol {
    
    var registry = [DeepLinkEntry]()
    
    func load() {
        //load list page urls
        registry.append(DeepLinkEntry(pattern: "https://www.example.com/details/{id}",
        closure: { (params) in
            let id = params.queryItems["id"] ?? ""
            // Open Details Screen
        }))
        
        
        registry.append(DeepLinkEntry(pattern: "https://www.example.com/list/page/{pageNo}",
        closure: { (params) in
            let pageNo = params.queryItems["pageNo"] ?? "1"
            let url = params.url
            // Open list Screen
        }))
        
        registry.append(DeepLinkEntry(pattern: "deeplink-app://list/{pageNo}",
        closure: { (params) in
            let pageNo = params.queryItems["pageNo"] ?? "1"
            let url = params.url
            // Open list Screen
        }))
        
        // for URLs with query params - https://www.example.com/search?query=test&item=save&id=23456
        registry.append(DeepLinkEntry(pattern: "https://www.example.com/search",
        closure: { (params) in
            let query = params.queryItems["query"] ?? ""
            let item = params.queryItems["item"] ?? ""
            let id = params.queryItems["id"] ?? ""
            // Open search Screen
        }))
        
    }
    
}
```
For more Examples/Unit Tests clone the repository and check `URLHandlers.swift` 
