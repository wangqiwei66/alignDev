//
//  HttpUtils.swift
//  Telematics
//
//  Licensed Materials - Property of IBM
//  6949 - XXX
//  (C)Copyright IBM Corp. 2015 All Rights Reserved
//  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//

import Foundation

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class HttpUtils {
    
    class var TIME_OUT: Int { return 1000 }
    
    private class func queryStringFromParameters(parameters: NSDictionary) -> String {
        
        let mutablePairs = NSMutableArray()
        for pair in parameters {
            let pairString = "\(pair.key)=\(pair.value)"
            mutablePairs.add(pairString)
        }
        return mutablePairs.componentsJoined(by: "&")
    }
    
    private class func createURL(url urlString: String, queryParameters: NSDictionary?) -> URL? {
        var retUrl:URL?
        if let url = URL(string: urlString){
            if let query = queryParameters {
                let queryString = queryStringFromParameters(parameters: query)
                let originalString = url.query == nil ? "\(urlString)?\(queryString)" : "\(urlString)&\(queryString)"
                if let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                    retUrl = URL(string: escapedString)
                }
            }
            retUrl = url
        }
        return retUrl
    }
    
    class func sendRequest(url urlString: String, httpMethod method: HttpMethod, queryParameters: NSDictionary?, headerFields: [String:String]?, bodyData data: NSDictionary?, success: @escaping ((Data) -> Void), failure: @escaping ((Int, String) -> Void) ) {
        
        // serialize params
        if let url = createURL(url: urlString, queryParameters: queryParameters){
            // init basic request
            let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: TimeInterval(HttpUtils.TIME_OUT))
            // add http headers
            if let headers = headerFields {
                request.allHTTPHeaderFields = headers as [String : String]
            }
            // init request with data
            let requestWithData: (_ request: NSMutableURLRequest) -> Void = {
                (request: NSMutableURLRequest) -> Void in
                if let dataDictionary = data {
                    if dataDictionary.count > 0 {
                        do {
                            let body = try JSONSerialization.data(withJSONObject: dataDictionary, options: JSONSerialization.WritingOptions())
                            request.httpBody = body
                        } catch{}
                    }
                }
            }
            // process by method type
            switch method {
            case .GET:
                request.httpMethod = HttpMethod.GET.rawValue
            case .POST:
                request.httpMethod = HttpMethod.POST.rawValue
                requestWithData(request)
            case .PUT:
                request.httpMethod = HttpMethod.PUT.rawValue
                requestWithData(request)
            case .DELETE:
                request.httpMethod = HttpMethod.DELETE.rawValue
            }
            // init url session
            let session = HttpUtils.getURLSession(timeout: HttpUtils.TIME_OUT)
            // process request
            HttpUtils.processRequest(session: session, request: request as URLRequest, success: success, failure: failure)
        }
    }
    
    class func getURLSession(timeout: Int) -> URLSession {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeout)
        return URLSession(configuration: config)
    }
    
    class func processRequest(session: URLSession, request: URLRequest, success: @escaping ((Data) -> Void), failure: @escaping ((Int, String) -> Void)) {
        let responseHandler = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse {
                // handle by status code
                let statusCode: Int = httpResponse.statusCode
                switch statusCode {
                case 200: success(data ?? Data())
                case 500: failure(statusCode, "Server internal error")
                default: failure(statusCode, "Network access error")
                }
            } else {
                failure(0, "Other network error")
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: responseHandler)
        task.resume()
    }
}
