//
//  VTConstants.swift
//  passManager
//
//  Created by Umair on 6/19/17.
//  Copyright © 2017 Umair. All rights reserved.
//

import Foundation
import UIKit

enum LeftMenu: Int {
    case profile = 0
    case home
    case favourite
    case payments
    case privacyPolicy
    case termsAndConditions
    case logOut
}

enum VTMessageType: Int {
    case error = 0
    case success
    case info
}

enum Genders: String {
    case MALE = "MALE"
    case FEMALE = "FEMALE"
    case male = "male"
    case female = "female"
}

enum BadgePosition: String {
    case topRight
    case topLeft
    case right
    case left
}

enum JobStatus: String {
    case accepted = "Accepted"
    case completed = "Completed"
    case inProgress = "On Going"
    case arrived = "Arrived"
    case open = "Open"
    case rejected = "Rejected"
    case cancelled = "Canceled"
    case finished = "Finished"
}

let kIsUserLoggedIn = "kIsUserLoggedIn"
let kLiveBaseUrl = "https://labourchoice.com/api/v1/"

let kStagingSocketUrl = "http://192.168.1.119:3400"
let kStagingBaseUrl = "http://192.168.1.119:3400/api/v1/"

//let kStagingSocketUrl = "http://54.191.103.99:3400"
//let kStagingBaseUrl = "http://54.191.103.99:3400/api/v1/"

let kJobAddress = "kJobAddress"
let kShouldLoadRejectJobData = "kShouldLoadRejectJobData"
let kLat = "KLat"
let KLong = "KLong"
let kDuration = "KDuration"
let kDescription = "kDescription"
let kStartTime = "kStartTime"
let kUserFirstName = "kUserFirstName"
let kUserLastName = "kUserLastName"
let kUserEmail = "kUserEmail"
let kUserId = "kUserId"
let kUserMobile = "kUserMobile"
let kUserProfileImageUrl = "kUserProfileImageUrl"
let kIsCardInfoAdded = "kIsCardInfoAdded"

// NSNotification

enum NotificationType: String {
    case jobAccepted = "Job Accepted"
    case jobArrived = "Job Arrived"
    case jobOngoing = "Job On Going"
    case labourStartWork = "labourStartWork"
    case jobCompleted = "Job Completed"
    case newMessage = "chatMessages"
    case jobTimedout = "Job Timedout"
    case jobClosed = "jobClosed"
    case jobRejected = "Job Rejected"
    case jobCanceled = "Job Canceled"
    case generalNotifications = "generalNotifications"
}

let kVTDidTapHomeNotification = "kVTDidTapHomeNotification"
let kVTAppDidEnterForeground = "kVTAppDidEnterForeground"
let kVTAppDidBecomeActive = "kVTAppDidBecomeActive"
let KVTReloadJobsNotification = "KVTReloadJobsNotification"
let kVTJobRejectedNotification = "kVTJobRejectedNotification"
let kVTLabourCompletedWorkNotification = "kVTLabourCompletedWorkNotification"
let kVTLabourOnWayNotification = "kVTLabourOnWayNotification"
let kVTJobCanceledNotification = "kVTJobCanceledNotification"
let kVTJobAcceptedNotification = "kVTJobAcceptedNotification"
let kVTJobClosedNotification = "kVTJobClosedNotification"
let kVTHomeJobRejectedNotification = "kVTHomeJobRejectedNotification"
let kVTHomeJobAcceptedNotification = "kVTHomeJobAcceptedNotification"
let kVTLabourStartedWorkNotification = "kVTLabourStartedWorkNotification"
let kVTLabourReachedNotification = "kVTLabourReachedNotification"
let kVTResetFiltersNotification = "kVTResetFiltersNotification"
let kVTNewMessageWhileChatingNotificaton = "kVTNewMessageWhileChatingNotificaton"
let kVTRefreshscheduledJobsNotification = "kVTRefreshscheduledJobsNotification"
let kDidFinishedRequestingHelpMateNotification = "kDidFinishedRequestingHelpMateNotification"

let kNewMessagePush = "Your received a message on "

// MARK: - Images

let kHamburgerImage = "icon_menu"
let kDoneNavigationBarImage = "icon_done"
let kFilterNavigationBarImage = "filter"
let kMarkerImage = "labour_icon"
let kPointerImage = "pointer"
let kAddCardImage = "add_card"
let kNonActiveCardImage = "non_active_card"
let kActiveCardImage =  "active_card"
let kCancelImage = "cancel"
let kSendButtonImage = "message_send_btn"
let kCalendarImage = "icon_date_time"
let kLocationImage = "icon_location"
let kLocationImage1 = "icon_location_2"
let kLocationImage2 = "icon_location_3"
let kLocationImage3 = "icon_location_4"

let kNoJobsImage = "no_scheduled_jobs"
let kDefaultCard = "default_card"
let kNoMessageImage = "no_msg"

let kCornerRadius : CGFloat = 2.0
var kOffSet = 20
let kLocation = "location"
let kSavedCookies = "savedCookies"

let kNotificationLoadDoneJobs = "kNotificationLoadDoneJobs"
let kNotificationChangeBarButton = "kNotificationChangeBarButton"
let kNotificationUpdateProfileImage = "kNotificationUpdateProfileImage"
let kNotificationOpenPaymentiewController = "kNotificationOpenPaymentiewController"

let kIsChatThreadCreated = "kIsChatThreadCreated"
let kErrorSessionExpired = "User is not authenticated."

let kContactUsEmail = "info@labourchoice.com.au"
let kContactUsCCEmail = "info@labourchoice.au"

let kTimedOutDescription = "Your labour is unable to accept a job request within given time. Kindly book a labour again."
let kTimedOutTitle = "The job request timed out."
let kNoPaymentDescription = "We need your credit card information in order to have payments processed for every job."
let kNoPaymentTitel = "No credit card added"
