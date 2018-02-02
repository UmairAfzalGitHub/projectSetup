//
//  APIClient.swift
//  Labour Choice
//
//  Created by talha on 19/06/2017.
//  Copyright © 2017 talha. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class Connectivity {

    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

let APIClientDefaultTimeOut = 40.0
let APIClientBaseURL = kStagingBaseUrl

class APIClient: APIClientHandler {

    fileprivate var clientDateFormatter: DateFormatter
    var isConnectedToNetwork: Bool?

    static let shared: APIClient = {
        let baseURL = URL(string: APIClientBaseURL)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIClientDefaultTimeOut

        let instance = APIClient(baseURL: baseURL!, configuration: configuration)

        return instance
    }()

    // MARK: - init methods

    override init(baseURL: URL, configuration: URLSessionConfiguration, delegate: SessionDelegate = SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
        clientDateFormatter = DateFormatter()

        super.init(baseURL: baseURL, configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)

//        clientDateFormatter.timeZone = NSTimeZone(name: "UTC")
        clientDateFormatter.dateFormat = "yyyy-MM-dd" // Change it to desired date format to be used in All Apis
    }

    // MARK: Helper methods

    func apiClientDateFormatter() -> DateFormatter {
        return clientDateFormatter.copy() as! DateFormatter
    }

    fileprivate func normalizeString(_ value: AnyObject?) -> String {
        return value == nil ? "" : value as! String
    }

    fileprivate func normalizeDate(_ date: Date?) -> String {
        return date == nil ? "" : clientDateFormatter.string(from: date!)
    }

    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }

    // MARK: - SignIn / SignUp

    @discardableResult
    func loginAsUser(mobileNumber: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "seeker/logIn"
        let params = ["mobileNumber": mobileNumber, "userType": "Seeker"] as [String:AnyObject]

        return sendRequest(serviceName, parameters: params, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func logout(_ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let serviceName = "seeker/logOut"

        return sendRequest(serviceName, parameters: nil, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    // MARK: - Chat

    @discardableResult
    func createJobThread(jobId: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let serviceName = "thread/create"
        let params = ["jobId": jobId] as [String : AnyObject]

        return sendRequest(serviceName, parameters: params, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func sendMessage(chatId: String, message: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        dateFormatter.string(from: Date())

        let serviceName = "message/\(chatId)/create"
        let params = ["message": message, "type": "text", "currentTime": dateFormatter.string(from: Date())] as [String : AnyObject]

        return sendRequest(serviceName, parameters: params, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func getPreviousChat(jobId: String, offSet: Int, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "thread/\(jobId)/\(offSet)/\(kOffSet)"

        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }

    // MARK: - Job Flow

    @discardableResult
    func getUnratedJobs( _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "job/latestJobRating"

        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }

    // MARK: - Payment

    @discardableResult
    func sendStripeToken(token: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "str/user/card/add"
        let params = ["token": token] as [String : AnyObject]

        return sendRequest(serviceName, parameters: params, isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func getStripeCustomer( _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "str/user"

        return sendRequest(serviceName, parameters: nil, isPostRequest: false, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func deleteUserCard(cardId: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "str/user/card/delete"
        let params = ["cardId": cardId]

        return sendRequest(serviceName, parameters: params as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    @discardableResult
    func changeDefaultCard(cardId: String, _ completionBlock: @escaping APIClientCompletionHandler) -> Request {
        let serviceName = "str/user/card/default"
        let params = ["cardId": cardId]
        return sendRequest(serviceName, parameters: params as [String : AnyObject], isPostRequest: true, headers: nil, completionBlock: completionBlock)
    }

    // MARK: - Image Uploading

    func uploadImage(image: UIImage, _ completionBlock: @escaping (_ success: Bool) -> Void ) {

        let rotatedImage = image.rotateImage()

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(rotatedImage.jpeg(.lowest)!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")

        }, to: URL(string: "\(kStagingBaseUrl)seeker/uploadProfileImage")!) { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })

                upload.responseJSON { response in

                    if let json = response.result.value as? [String:Any] {

                        if let data = Mapper<ProfileImage>().map(JSONObject: json) {
                            print(data.imageUrl)
                            User.shared.profileImageURL = data.imageUrl
                            UserDefaults.standard.set(data.imageUrl, forKey: kUserProfileImageUrl)
                            completionBlock(true)
                        }
                    }
                }

            case .failure( _):
                completionBlock(false)
                //print encodingError.description
            }
        }
    }

}
