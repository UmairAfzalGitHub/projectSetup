//
//  APIClientHandler.swift
//  Labour Choice
//
//  Created by talha on 19/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

typealias APIClientCompletionHandler = (_ result: AnyObject?, _ error: NSError?) -> Void

enum APIClientHandlerErrorCode: Int {
    case general = 30001
    case noNetwork = 30002
    case timeOut = 30003
}

let APIClientHandlerErrorDomain = "com.VT.webserviceerror"
let APIClientHandlerDefaultErrorDescription = "Operation failed" //"Operation failed"

class APIClientHandler: TSAPIClient {

    func sendRequest(_ methodName: String,
                     parameters: [String : AnyObject]?,
                     isPostRequest: Bool,
                     headers: [String : String]?,
                     completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let request = self.serverRequest(methodName, parameters: parameters, isPostRequest: isPostRequest, headers: headers) { (response, result, error) in
            print(result ?? "no result")

            if error != nil {
                var apiError = error

                if error?.code == NSURLErrorNotConnectedToInternet {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "No network found"]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.noNetwork.rawValue, andErrorInfo: userInfo)

                } else {
                    let userInfo : [String: Any] = [NSLocalizedDescriptionKey : "Connecting to network ...."]
                    apiError = self.createErrorWithErrorCode(APIClientHandlerErrorCode.timeOut.rawValue, andErrorInfo: userInfo)
                }

                DispatchQueue.main.async { // Correct
                    completionBlock(nil, apiError)
                }

            } else {

                var sendError = false
                var sendMessage = false
                var status = false
                var success = false
                var errorMessage = ""
                var message = ""
                var resultError: NSError?
                var resultData: AnyObject?

                if let responseHandler = Mapper<VTResponseHandler>().map(JSONObject:result) {
                    status = responseHandler.status
                    success = responseHandler.success
                    errorMessage = responseHandler.error
                    message = responseHandler.message

                    if status && success {
                        resultData = responseHandler.data

                        if resultData == nil {
                            resultData = true as AnyObject?
                        }

                    } else if !success && message != "" {
                        sendMessage = true

                    } else {
                        sendError = true
                    }

                } else {
                    sendError = true
                }

                if sendError {
                    resultError = self.createError(errorMessage)

                    DispatchQueue.main.async { // Correct
                        completionBlock(nil, resultError)
                    }

                } else if sendMessage {
                    resultError = self.createError(message)

                    DispatchQueue.main.async { // Correct
                        completionBlock(nil, resultError)
                    }
 
                } else {

                    DispatchQueue.main.async { // Correct
                        completionBlock(resultData, nil)
                    }
                }
            }
        }

        return request
    }

    // MARK: - Private methods

    func createError(_ errorDescription: String) -> NSError {
        var description = APIClientHandlerDefaultErrorDescription

        //print(errorDescription)
        if errorDescription.count > 0 {
            description = errorDescription
        }

        let userInfo : [String: Any] = [NSLocalizedDescriptionKey : description]

        return createErrorWithErrorCode(APIClientHandlerErrorCode.general.rawValue, andErrorInfo: userInfo)
    }

    func createErrorWithErrorCode(_ code: Int, andErrorInfo info: [String: Any]?) -> NSError {
        return NSError(domain: APIClientHandlerErrorDomain, code: code, userInfo: info)
    }
    
}
