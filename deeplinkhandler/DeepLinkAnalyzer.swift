//
//  DeepLinkAnalyzer.swift
//  deeplinkhandler
//
//  Created by Sahil Dudeja on 5/1/17.
//
//

import Foundation

class DeepLinkAnalyzer: DeepLinkAnalyzerProtocol {
    
    var registry = [DeepLinkEntry]()
    
    fileprivate func load() {
        //load list page urls
        registry.append(DeepLinkEntry(pattern: URLProvider.listWithPage, closure: URLProvider.handListWithPage))
        registry.append(DeepLinkEntry(pattern: URLProvider.listUrl, closure: URLProvider.handList))
        //load list page custom scheme urls
        registry.append(DeepLinkEntry(pattern: URLProvider.listWithPageCustom, closure: URLProvider.handListWithPage))
        registry.append(DeepLinkEntry(pattern: URLProvider.listUrlCustom, closure: URLProvider.handList))
        
        //load details page urls
        registry.append(DeepLinkEntry(pattern: URLProvider.detailsType2, closure: URLProvider.handleDeepLinkDetails2))
        registry.append(DeepLinkEntry(pattern: URLProvider.detailsType3, closure: URLProvider.handleDeepLinkDetails3))
        registry.append(DeepLinkEntry(pattern: URLProvider.details, closure: URLProvider.handleDetails))
        //load details page custom scheme urls
        registry.append(DeepLinkEntry(pattern: URLProvider.detailsType2Custom, closure: URLProvider.handleDeepLinkDetails2))
        registry.append(DeepLinkEntry(pattern: URLProvider.detailsType3Custom, closure: URLProvider.handleDeepLinkDetails3))
        registry.append(DeepLinkEntry(pattern: URLProvider.detailsCustom, closure: URLProvider.handleDetails))
        
        //load search page urls
        registry.append(DeepLinkEntry(pattern: URLProvider.search, closure: URLProvider.handleSearch))
        //load search page custom scheme urls
        registry.append(DeepLinkEntry(pattern: URLProvider.searchCustom, closure: URLProvider.handleSearch))
        
    }
    
    func parseURL(url: URL) -> Bool {
        load()
        if let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true), let path = components.path, let scheme = components.scheme, let host = components.host {
            self.load()
            let deepLinkPath = scheme + "://" + host + path
            //let range = NSRange(location: 0, length: deepLinkPath.characters.count)
            for entry in registry {
                if entry.isMatchingWithPattern(url: deepLinkPath) {
                    //return entry.openScreen(url: deepLinkPath + (components.query ?? ""), queryItems: components.queryItems)
                    return entry.openScreen(url: url.absoluteString, queryItems: components.queryItems)
                }
            }
            
            if host == "www.example.com" {
                // fallback to url
                // let model = DeepLinkModel(type: .webview(url: url.absoluteString))
                // return URLProvider.setForLaunch(deepLinkModel: model)
            }
        }
        return false

    }
}
