import UIKit
import WebKit

//MARK: - Manage Cookies
/*
 Sub resources come up with HTTP Request
 Server respond the HTTP request with resources and some metadata about resources
 Both request and response have little data called cookies.
 When server responds a cookie, browser remember the cookie and send it again in next requests.
 With cookies we can track the user session. -> Login token, shopping cart state
 */

/*
 Manage Cookies -> WKHTTPCookieStore
 Add and remove individual cookies.
 Access all cookies visible to a WKWebView. Including HTTP-only cookies.
 Oberserve the cookie store for changes.
 */

var webView = WKWebView()
let cookieStore = webView.configuration.websiteDataStore.httpCookieStore

let cookie = HTTPCookie(properties: [
    HTTPCookiePropertyKey.domain: "canineschool.org",
    HTTPCookiePropertyKey.path: "/",
    HTTPCookiePropertyKey.secure: true,
    HTTPCookiePropertyKey.name: "LoginSessionId",
    HTTPCookiePropertyKey.value: "234o24on456n2409235029532nj5230525"])

let request = URLRequest(url: URL(string: "test.com.tr")!)
// Remark that this process is async with completion handler.
// Because it needs to send out to all processes that isolated from your application.
// Any request in the completion handler, ensure that has the desired cookie.
cookieStore.setCookie(cookie!) {
    webView.load(request)
}

// Retrueve the set of all cookies in a WKWebsiteDataStore
cookieStore.getAllCookies { (cookies) in
    for cookie in cookies{
        print(cookie.name)
        //Find login cookie and logout the user. -> webView.load(loggedOutURLRequest)
    }
}

//MARK: - Filtering Unwanted Content
/*
 WKContentRuleList -> Provide a way to filtering unwanted content
 Same syntax as Content Blocked extensions for Safari
 -  Block Loads: Regex matching to block url
 -  Make content invisible: Load the content and make some invisible
 -  Make insecure loads secure: convert http to https encrypted format and block cookies to be sent.
 Webkit compiles your rules into efficient bytecode. -> Even if thousands rule they dont effect the loading performance.
 
 */

// You supply rules in JSON
let jsonString = """
    [{
        "trigger": {
            "url-filter" = ".*"
        },
        "action:{
            "type": "make-https"
        }
    }]
"""

func loadJSONFromBundle() -> String{
    return jsonString
}

func createWebViewWithContentRulesList(_ ruleList: WKContentRuleList){
    // Add compile WKContentRuleList to your WKWebView's configuration
    let configuration = WKWebViewConfiguration()
    configuration.userContentController.add(ruleList)
}

// Load rule list from json and create web view to load web content with desired rules.
let json = loadJSONFromBundle()
WKContentRuleListStore
    .default()?
    .compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: json) { (ruleList, error) in
        guard error == nil else { return }
        createWebViewWithContentRulesList(ruleList!)
}

// Access previously compilet WKContentRuleList
WKContentRuleListStore.default()?.lookUpContentRuleList(forIdentifier: "ContentBlockingRules") { (ruleList, error) in
    guard error == nil else { return }
    // Use previously compule content rule list.
}

//MARK: - Demo

let cookie2 = HTTPCookie(properties: [
    HTTPCookiePropertyKey.domain: "canineschool.org",
    HTTPCookiePropertyKey.path: "/",
    HTTPCookiePropertyKey.secure: true,
    HTTPCookiePropertyKey.name: "LoginSessionId",
    HTTPCookiePropertyKey.value: "234o24on456n2409235029532nj5230525"])

let websiteDataStore = WKWebsiteDataStore.nonPersistent()
websiteDataStore.httpCookieStore.setCookie(cookie2!){
    let configuration = WKWebViewConfiguration()
    configuration.websiteDataStore = websiteDataStore
    
    webView = WKWebView(frame: CGRect.zero, configuration: configuration)
    // self.view = self.webView
    webView.load(URLRequest(url: URL(string: "Some web url")!))
}

//MARK: - Provide Custom Resources
/*
 WKURLSchemeHandler -> Allows to handle resource loads for particle url scheme
 URLScheme -> https - file - mailto
 Only custom URL schemes that Webkit doesn't handle itself.
 */

let customScheme = "apple-local"
var task: WKURLSchemeTask!

class MyCustomSchemeHandler: NSObject, WKURLSchemeHandler{
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        let resourceData = Data()
        task = urlSchemeTask
        let response = URLResponse(url: urlSchemeTask.request.url!,
                                   mimeType: "text/html",
                                   expectedContentLength: resourceData.count,
                                   textEncodingName: nil)
        
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(resourceData)
        urlSchemeTask.didFinish()
    }
    
    // After a point now you can use task to didReceive(_ data:), didReceive(_ response:) and didFinish() on task.
}

let configuration2 = WKWebViewConfiguration()
configuration2.setURLSchemeHandler(MyCustomSchemeHandler(), forURLScheme: "apple-local")

let webView2 = WKWebView(frame: CGRect.zero, configuration: configuration2)
webView2.load(URLRequest(url: URL(string: "apple-local:top")!))

/*
 Choose a future-proof URL scheme
 Delivered image data asynchronously
 You can complete and load data after you complete you desired task.
 */
