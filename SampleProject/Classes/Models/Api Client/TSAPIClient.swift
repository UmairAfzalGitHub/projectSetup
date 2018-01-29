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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


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

/*
    func serverMultiFormRequest(_ methodName: String, param: [String : AnyObject]?, image: UIImage?, imageName: String, completionBlock: @escaping TSAPIClientCompletionBlock) {
        var parameters: [String : AnyObject] = [:]

        if param != nil {
            parameters = param!
        }

        let url = URL(string: methodName, relativeTo: serviceURL)
        let myURL = try! URLRequest(url: url!, method: .post, headers: nil)
        print("\(url)")

        upload(multipartFormData: { (multipartFormData) in

            if let anImage = image {

                if let imageData = UIImageJPEGRepresentation(anImage, 0.5) {
                    multipartFormData.append(imageData, withName: imageName, fileName: imageName+".jpg", mimeType: "image/jpeg")
                }
            }

            for (key, value) in parameters {
                multipartFormData.append(data: value.data(using: String.Encoding.utf8.rawValue)!, name: key)
            }

        }, to: myURL as! URVTonvertible, encodingCompletion: { (result) in
            // code
        })


        upload(.post, url!, multipartFormData: {
            multipartFormData in

            if let anImage = image {

                if let imageData = UIImageJPEGRepresentation(anImage, 0.5) {
                    multipartFormData.appendBodyPart(data: imageData, name: imageName, fileName: imageName+".jpg", mimeType: "image/jpeg")
                }
            }

            for (key, value) in parameters {
                multipartFormData.appendBodyPart(data: value.data(using: String.Encoding.utf8)!, name: key)
            }

        }, encodingCompletion: {
            encodingResult in

            switch encodingResult {

            case .success(let upload, _, _):
                upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                    print("Bytes Written \(bytesWritten) \n totalBytes writted \(totalBytesWritten) \n expected \(totalBytesExpectedToWrite)")
                }

                upload.responseJSON(completionHandler: { response in

                    switch response.result {
                    case .success:
                        print(response.result.value)
                        completionBlock(response: response.response, result: response.result.value, error: nil)

                        break
                    case .failure(let error):
                        print(error)
                        completionBlock(response: response.response, result: nil, error: error)
                        
                        break
                    }
                })
            case .failure(let encodingError):
                // completionBlock(request: Request(), result: nil, error: encodingError)
                print(encodingError)
            }
        })
    }
    
*/
    func cancelAllRequests() {
        session.getAllTasks { tasks in

            for task in tasks {
                task.cancel()
            }
        }
    }
}
