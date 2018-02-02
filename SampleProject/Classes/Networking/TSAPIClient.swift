//
//  TSAPIClient.swift
//  YAS
//
//  Created by Tranzbox Limited on 26/05/16.
//  Copyright © 2016 Tech-Spiders. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator

typealias TSAPIClientCompletionBlock = (_ response: HTTPURLResponse?, _ result: AnyObject?, _ error: NSError?) -> Void

// MARK: -

class TSAPIClient: SessionManager {

    // MARK: - Properties methods

    fileprivate var serviceURL: URL?

    // MARK: - init & deinit methods

    init(baseURL: URL,
         configuration: URLSessionConfiguration = URLSessionConfiguration.default,
         delegate: SessionDelegate = SessionDelegate(),
         serverTrustPolicyManager: ServerTrustPolicyManager? = nil){

        super.init(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)

        var aURL = baseURL

        // Ensure terminal slash for baseURL path, so that NSURL relativeToURL works as expected

        if aURL.path.count > 0 && !aURL.absoluteString.hasSuffix("/") {
            aURL = baseURL.appendingPathComponent("")
        }

        serviceURL = baseURL
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }

    // MARK: - Public methods

    func serverRequest(_ methodName: String, parameters: [String : AnyObject]? , isPostRequest: Bool, headers: [String : String]?, completionBlock: @escaping TSAPIClientCompletionBlock) -> Request {

        let url = URL(string: methodName, relativeTo: serviceURL)
        print("\(String(describing: url))")

        Utility.loadCookies()

        if isPostRequest {

            let request = self.request(url!, method: .post , parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseJSON { response in

                    if methodName == "seeker/account/create" || methodName == "seeker/login/verification" {
                        Utility.saveCookies(response: response)
                    }

                    switch response.result {

                    case .success:
                        completionBlock(response.response, response.result.value as AnyObject?, nil)
                        break

                    case .failure(let error):
                        completionBlock(response.response, nil, error as NSError?)
                        break
                    }
            }

            return request

        } else {

            let request = self.request(url!, method: .get , parameters: parameters, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<600)
                .responseJSON { response in

                    switch response.result {

                    case .success:
                        completionBlock(response.response, response.result.value as AnyObject?, nil)
                        break

                    case .failure(let error):
                        completionBlock(response.response, nil, error as NSError?)
                        break
                    }
            }
            
            return request
            
        }
    }

    func cancelAllRequests() {
        session.getAllTasks { tasks in

            for task in tasks {
                task.cancel()
            }
        }
    }
}
