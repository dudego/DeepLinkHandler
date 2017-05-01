//
//  URLHandlers.swift
//  deeplinkhandler
//
//  Created by Sahil Dudeja on 5/1/17.
//
//

import Foundation
struct URLProvider {
    
    static let host_url = "https://www.example.com"
    static let host_scheme_url = "link-app://com.abc"
    
    struct Params {
        static let param1 = "param1"
        static let param2 = "params2"
        static let param3 = "param3"
        static let pageParam = "page"
        static let searchQuery = "searchQuery"
    }
    
    static let listUrl = host_url + "/list" // https://www.example.com/list
    static let listWithPage = host_url + "/list/{\(Params.pageParam)}" // https://www.example.com/{page}
    static let details = host_url + "/details/{\(Params.param1)}"
    static let detailsType2 = host_url + "/details/{\(Params.param1)}/products/{\(Params.param2)}"
    static let detailsType3 = host_url + "legacyDetails/{\(Params.param1)}/{\(Params.param2)}/products/{\(Params.param3)}"
    static let search = host_url + "/search"
    
    static let listUrlCustom = host_scheme_url + "/list" // deeplink-app://com.dudego.deeplinks/list
    static let listWithPageCustom = host_scheme_url + "/list/{\(Params.pageParam)}" // deeplink-app://com.dudego.deeplinks/{page}
    static let detailsCustom = host_scheme_url + "/details/{\(Params.param1)}"
    static let detailsType2Custom = host_scheme_url + "/details/{\(Params.param1)}/products/{\(Params.param2)}"
    static let detailsType3Custom = host_scheme_url + "legacyDetails/{\(Params.param1)}/{\(Params.param2)}/products/{\(Params.param3)}"
    static let searchCustom = host_scheme_url + "/search"
    
    
    static let handList: DeepLinkClosure = { (params) in
        var model = DeepLinkModel(type: .list, url: params.url)
        return URLProvider.setForLaunch(deepLinkModel: model)
    }
    
    static let handListWithPage: DeepLinkClosure = { (params) in
        var model = DeepLinkModel(type: .listWithPageParam(page: params.queryItems[Params.pageParam]!), url: params.url)
        return URLProvider.setForLaunch(deepLinkModel: model)
    }
    
    static let handleDetails: DeepLinkClosure = { (params) in
        let model = DeepLinkModel(type: .details(param1: params.queryItems[Params.param1]!), url: params.url)
        return URLProvider.setForLaunch(deepLinkModel: model)
    }
    
    static let handleDeepLinkDetails2 : DeepLinkClosure = { (params) in
        let model = DeepLinkModel(type: .detailsType2(param1: params.queryItems[Params.param1]!, param2: params.queryItems[Params.param2]!), url: params.url)
        return URLProvider.setForLaunch(deepLinkModel: model)
    }
    
    static let handleDeepLinkDetails3 : DeepLinkClosure = { (params) in
        if let param3 = params.queryItems[Params.param3], !param3.contains("legacy") {
            let model = DeepLinkModel(type: .detailsType2(param1: params.queryItems[Params.param1]!, param2: params.queryItems[Params.param2]!), url: params.url)
            return URLProvider.setForLaunch(deepLinkModel: model)
        }
        return false
    }
    
    static let handleSearch: DeepLinkClosure = { (params) in
        if let query = params.queryItems[Params.searchQuery] {
            let model = DeepLinkModel(type: .search(queryParam: query), url: params.url)
            return URLProvider.setForLaunch(deepLinkModel: model)
        }
        return false
    }
    
    static func setForLaunch(deepLinkModel: DeepLinkModel) -> Bool {
        AppDelegate.openVc(model: deepLinkModel)
        return true
    }
    
}

struct DeepLinkModel {
    let type: DeepLinkType
    let url: String
    enum DeepLinkType {
        case list,
        listWithPageParam(page: String),
        details(param1: String),
        detailsType2(param1: String, param2: String),
        search(queryParam: String)
    }
    
    func toString() -> String{
         return ("url: \(url) \n type: \(type.toString())")
    }
}

extension DeepLinkModel.DeepLinkType: Equatable {
    
    static func == (lhs: DeepLinkModel.DeepLinkType, rhs: DeepLinkModel.DeepLinkType) -> Bool {
        
        switch (lhs, rhs) {
        case (.list, .list):
            return true
        case (let listWithPageParam(page), let listWithPageParam(page1)):
            return page == page1
        case (let .details(param), let .details(param1)):
            return param == param1
        case (let .detailsType2(param1, param2), let .detailsType2(param3, param4)):
            return param1 == param3 && param2 == param4
        case (let search(queryParam), let search(queryParam1)):
            return queryParam == queryParam1
        default:
            return false
        }
        
    }
    
}

extension DeepLinkModel.DeepLinkType {
    
    func toString() -> String {
        switch self {
        case .list:
            return ("list - no params")
        case .listWithPageParam(let page):
            return ("list with page: \(page)")
        case .details(let param1):
            return ("details param1: \(param1)")
        case .detailsType2(let param1, let param2):
            return ("detailsType2 param1: \(param1), param2: \(param2)")
        case .search(let queryParam):
            return ("search queryParam:\(queryParam)")
        }
    }
}
