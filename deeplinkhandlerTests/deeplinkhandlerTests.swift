//
//  deeplinkhandlerTests.swift
//  deeplinkhandlerTests
//
//  Created by Sahil Dudeja on 5/1/17.
//
//

import XCTest
@testable import deeplinkhandler

class deeplinkhandlerTests: XCTestCase {
    
    let listUrl = URLProvider.host_url + "/list"
    let listWithPage = URLProvider.host_url + "/list/1"
    let details = URLProvider.host_url + "/details/sampleDetails"
    let detailsType2 = URLProvider.host_url + "/details/sample-details/products/testid"
    let detailsType3Fail = URLProvider.host_url + "legacyDetails/sample-detail/testid2/products/legacy-1233"
    let detailsType3 = URLProvider.host_url + "legacyDetails/sample-detail/testid2/products/new-1233"
    let search = URLProvider.host_url + "/search?searchQuery=testquery"
    let searchFail = URLProvider.host_url + "/search"
    
    let listUrlCustom = URLProvider.host_scheme_url + "/list"
    let listWithPageCustom = URLProvider.host_scheme_url + "/list/1"
    let detailsCustom = URLProvider.host_scheme_url + "/details/sampleDetails"
    let detailsType2Custom = URLProvider.host_scheme_url + "/details/sample-details/products/testid"
    let detailsType3FailCustom = URLProvider.host_scheme_url + "legacyDetails/sample-detail/testid2/products/legacy-1233"
    let detailsType3Custom = URLProvider.host_scheme_url + "legacyDetails/sample-detail/testid2/products/new-1233"
    let searchCustom = URLProvider.host_scheme_url + "/search?searchQuery=testquery"
    let searchFailCustom = URLProvider.host_scheme_url + "/search"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.continueAfterFailure = false
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testList() {
        XCTAssertTrue(setMyDeepLink(url: listUrl) == .list)
    }
    
    func testListWithPage() {
        XCTAssertTrue(setMyDeepLink(url: listWithPage) == .listWithPageParam(page: "1"))
    }
    
    func testDetailsPage() {
        XCTAssertTrue(setMyDeepLink(url: details) == .details(param1: "sampleDetails"))
    }
    
    func testDetailsType2() {
        XCTAssertTrue(setMyDeepLink(url: detailsType2) == .detailsType2(param1: "sample-details", param2: "testid"))
    }
    
    func testDetailsType3() {
        XCTAssertTrue(setMyDeepLink(url: detailsType3) == .detailsType2(param1: "sample-detail", param2: "testid2"))
    }
    
    func testDetailsType3Fail() {
        setMyDeepLinkFail(url: detailsType3Fail)
    }
    func testSearch() {
        XCTAssertTrue(setMyDeepLink(url: search) == .search(queryParam: "testquery"))
    }
    
    func testSearchFail() {
        setMyDeepLinkFail(url: searchFail)
    }
    
    
    func testListCustom() {
        XCTAssertTrue(setMyDeepLink(url: listUrl) == .list)
    }
    
    func testListWithPageCustom() {
        XCTAssertTrue(setMyDeepLink(url: listWithPageCustom) == .listWithPageParam(page: "1"))
    }
    
    func testDetailsPageCustom() {
        XCTAssertTrue(setMyDeepLink(url: detailsCustom) == .details(param1: "sampleDetails"))
    }
    
    func testDetailsType2Custom() {
        XCTAssertTrue(setMyDeepLink(url: detailsType2Custom) == .detailsType2(param1: "sample-details", param2: "testid"))
    }
    
    func testDetailsType3Custom() {
        XCTAssertTrue(setMyDeepLink(url: detailsType3Custom) == .detailsType2(param1: "sample-detail", param2: "testid2"))
    }
    
    func testDetailsType3FailCustom() {
        setMyDeepLinkFail(url: detailsType3FailCustom)
    }
    func testSearchCustom() {
        XCTAssertTrue(setMyDeepLink(url: searchCustom) == .search(queryParam: "testquery"))
    }
    
    func testSearchFailCustom() {
        setMyDeepLinkFail(url: searchFailCustom)
    }

    
    func setMyDeepLink(url: String) ->  DeepLinkModel.DeepLinkType {
        let bool = DeepLinkAnalyzer().parseURL(url: URL(string: url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
            )!)
        XCTAssertTrue(bool)
        XCTAssertTrue(CachingManager.shared.model != nil)
        XCTAssert(CachingManager.shared.model!.url == url)
        return CachingManager.shared.model!.type
    }
    
    func setMyDeepLinkFail(url: String){
        let bool = DeepLinkAnalyzer().parseURL(url: URL(string: url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
            )!)
        XCTAssertTrue(!bool)
    }
}
