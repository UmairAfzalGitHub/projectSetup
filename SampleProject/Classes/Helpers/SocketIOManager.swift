//
//  SocketIOManager.swift
//  Help Connect
//
//  Created by Umair Afzal on 09/01/2018.
//  Copyright © 2018 Umair Afzal. All rights reserved.
//

import Foundation
import SocketIO
import ObjectMapper

protocol SocketIOManagerDelegate {
    func didReceiveJobCompletionEvent(jobId: String)
    func didReceiveJobFlowEvent()
    func didReceiveJobCancelationEvent(jobId: String)
    func didReceiveJobRejectionEvent(jobId: String)
    func didReceiveNewMessage(jobId: String, message: String, senderId: String)
}

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    var delegate: SocketIOManagerDelegate?

    override init() {
        super.init()
    }

    var socketManager = SocketManager(socketURL: URL(string: kStagingSocketUrl)!, config: [.log(true), .compress])
    var socket: SocketIOClient?

    func establishConnection() {
        socket?.disconnect() // to make sure that mutiple sockets are not connected
        print("Connecting Socket.....................")
        socket?.connect(timeoutAfter: 5, withHandler: {
            self.establishConnection()
            print("Error in Connecting Socket")
        })
    }

    func closeConnection() {
        socket?.disconnect()
        print("Socket is DisConnected ")
    }

    func oberveAllEvents() {
        observeJobAccecptedEvent()
        observeJobRejectedEvent()
        observeJobCompletedEvent()
        observeJobOngoingEvent()
        observeJobArrivedEvent()
        observeNewMessageEvent()
        observeJobTimeOutEvent()
        observeJobCancelEvent()
    }

    func observeJobAccecptedEvent() {

        socket?.on(NotificationType.jobAccepted.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Accepted \(dataArray[0])")
            self.delegate?.didReceiveJobFlowEvent()
            Utility.showInAppNotification(title: "Job status changed", message: "Your job is ACCEPTED by helpmate", identifier: NotificationType.generalNotifications.rawValue)
        }
    }

    func observeJobRejectedEvent() {

        socket?.on(NotificationType.jobRejected.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Reject \(dataArray[0])")

            if let event = dataArray[0] as? NSDictionary {

                if let socketData = event["socket"] as? NSDictionary {

                    if let data = Mapper<UserPushNotitfication>().map(JSONObject: socketData) {
                        self.delegate?.didReceiveJobRejectionEvent(jobId: data.jobId)
                        Utility.showInAppNotification(title: "Job status changed", message: "Your job is REJECTED by helpmate", identifier: NotificationType.generalNotifications.rawValue)
                    }
                }
            }
        }
    }

    func observeJobCompletedEvent() {

        socket?.on(NotificationType.jobCompleted.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Completed \(dataArray[0])")

            if let event = dataArray[0] as? NSDictionary {

                if let socketData = event["socket"] as? NSDictionary {

                    if let data = Mapper<UserPushNotitfication>().map(JSONObject: socketData) {
                        self.delegate?.didReceiveJobCompletionEvent(jobId: data.jobId)
                        Utility.showInAppNotification(title: "Job status changed", message: "Your job is COMPLETED by helpmate", identifier: NotificationType.generalNotifications.rawValue)
                    }
                }
            }
        }
    }

    func observeJobOngoingEvent() {

        socket?.on(NotificationType.jobOngoing.rawValue) { (dataArray, ack) in
            print("Socket Event: Job OnGoing \(dataArray[0])")
            self.delegate?.didReceiveJobFlowEvent()
            Utility.showInAppNotification(title: "Job status changed", message: "Your job is ON GOING by helpmate", identifier: NotificationType.generalNotifications.rawValue)
        }
    }

    func observeJobCancelEvent() {

        socket?.on(NotificationType.jobCanceled.rawValue) { (dataArray, ack) in
            print("Socket Event: Job canceled \(dataArray[0])")

            if let event = dataArray[0] as? NSDictionary {

                if let socketData = event["socket"] as? NSDictionary {

                    if let data = Mapper<UserPushNotitfication>().map(JSONObject: socketData) {
                        self.delegate?.didReceiveJobCancelationEvent(jobId: data.jobId)
                        Utility.showInAppNotification(title: "Job canceled", message: "Your job is Canceled by helpmate", identifier: NotificationType.generalNotifications.rawValue)
                    }
                }
            }
        }
    }

    func observeJobArrivedEvent() {

        socket?.on(NotificationType.jobArrived.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Arrived \(dataArray[0])")
            self.delegate?.didReceiveJobFlowEvent()
            Utility.showInAppNotification(title: "Job status changed", message: "Your helper has arrived on job location", identifier: NotificationType.generalNotifications.rawValue)
        }
    }

    func observeNewMessageEvent() {

        socket?.on(NotificationType.newMessage.rawValue) { (dataArray, ack) in
            print("Socket Event: New Message \(dataArray[0])")

            if let event = dataArray[0] as? NSDictionary {

                if let socketData = event["message"] as? NSDictionary {

                    if let data = Mapper<Message>().map(JSONObject: socketData) {

                        self.delegate?.didReceiveNewMessage(jobId: data.jobId, message: data.body, senderId: data.senderId)

                        if data.jobId != User.shared.isChatingWithId {
                            let userInfo = ["aps":["jobId": data.jobId, "type": "chatMessages", "senderName": "DummyName"]]
                            Utility.showInAppNotification(title: "New message", message: data.body, identifier: "SomeDummyIdentifier", userInfo: userInfo)
                        }
                    }
                }
            }
        }
    }

    func observeJobTimeOutEvent() {

        socket?.on(NotificationType.jobTimedout.rawValue) { (dataArray, ack) in
            print("Socket Event: Job Arrived \(dataArray[0])")

            if let event = dataArray[0] as? NSDictionary {

                if let socketData = event["socket"] as? NSDictionary {

                    if let data = Mapper<UserPushNotitfication>().map(JSONObject: socketData) {
                        self.delegate?.didReceiveJobRejectionEvent(jobId: data.jobId)
                        Utility.showInAppNotification(title: "Job request timedout", message: "Your job request timed out", identifier: NotificationType.generalNotifications.rawValue)
                    }
                }
            }
        }
    }

    func sendMessage(message: String, jobId: String) {
        let data = ["message": message, "jobId": jobId, "type": "text"]
        socket?.emit("chatMessages", data)
        print("Chat Message Sent")
    }
}
