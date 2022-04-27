//
//  EndPoints.swift
//  NewProjectApi
//
//  Created by Pallavi Jain on 03/05/21.
//


import Foundation

enum EndPoints : String {
    
    //MARK: - Base URLs
    
    case BASE_URL                     =     "http://139.59.0.106:3000/api/user/"
    case BASE_URL_IMAGE               =     "http://139.59.0.106:3000"
    
    //MARK: - Account URLs -
    
    
    case login                   =        "login"
    case register                =        "register"
    case otp                     =        "verify-otp"
    case resendOTP               =        "resend-verify-otp"
    case getInterested           =        "get-interested"
    case getRestaurent           =        "get-restaurants"
    case updateProfile           =        "update-profile"
    case forgotPassword          =        "forgot-password-sent-otp"
    case resetPassword           =        "reset-password"
    case updateProfileImage      =        "update-profile-image"
    case update_profile_video    =        "update-profile-video"
    case socialLogin             =        "social-signin"
    case updateUserName          =        "update-username"
    case getUsersSuggestions     =        "get-users-suggestions"
    case addFriendRequest        =        "add-friend-request"
    case get_post_feed           =        "get-post-feed"
    case add_post_like_unlike    =        "add-post-like-unlike"
    case post_file_save_gallery  =        "post-file-save-gallery"
    case get_friends_list        =        "get-friends-list"
    case add_media               =        "add-media"
    case add_post_feed           =        "add-post-feed"
    case get_profile_details     =        "get-profile-details"
    case get_my_post_feed        =        "get-my-post-feed"
    case get_post_save_gallery   =        "get-post-save-gallery"
    case get_user_match_list     =        "get-user-match-list"
    case add_user_match_request  =        "add-user-match-request"
    case get_notifications       =        "get-notifications"
    case match_request_status_update       =        "match-request-status-update"
    case friend_request_status_update      =        "friend-request-status-update"
    case update_notification      =        "update-notification"
    case add_post_comment       =        "add-post-comment"
    case get_post_comments      =        "get-post-comments"
    case delete_post_comment    =        "delete-post-comment"
    case reported_post_comment    =        "reported-post-comment"
    case change_password          =        "change-password"
    case remove_friend          =        "remove-friend"
    case post_notification_on_off          =        "post-notification-on-off"
    case add_user_report_block          =        "add-user-report-block"
    case get_user_blocked          =        "get-user-blocked"
    case remove_user_report_block          =        "remove-user-report-block"
    case delete_post          =        "delete-post"
    case post_comment_on_off          =        "post-comment-on-off"
    case create_date_get_partner_list = "create-date-get-partner-list"
    case create_date_request_partner = "create-date-request-partner"
    case create_date_get_my_partner_request = "create-date-get-my-partner-request"
    case get_restaurant_details = "get-restaurant-details"
    case purchase_coupons = "purchase-coupons"
    case join_couple_code          =        "join-couple-code"
    case get_couple_profile          =        "get-couple-profile"
    case get_coupons          =        "get-coupons"
    case get_my_coupons          =        "get-my-coupons"
    case get_faq          =        "get-faq"
    case updateStatusRelationship          =        "update-status-relationship"
    case createRelationship          =        "create-relationship"
    case leaveRelationship          =        "leave-relationship"
    case delete_date_request          =        "delete-date-request"
    case create_date_status_update_request_partner          =        "create-date-status-update-request-partner"
    case get_chat_users = "get-chat-users"
    case get_chat_message = "get-chat-message"
    case add_chat_media = "add-chat-media"
    case delete_chat_room = "delete-chat-room"
    case add_chat_request = "add-chat-request"
    case chat_request_status_update = "chat-request-status-update"
    case get_notifications_count = "get-notifications-count"
    case delete_chat_message = "delete-chat-message"
    case add_business_image = "add-business-image"
    case get_business_coupons = "get-business-coupons"
    case add_business_coupon = "add-business-coupon"
    case update_business_coupon = "update-business-coupon"
    case get_packages = "get-packages"
    case delete_business_coupon = "delete-business-coupon"
    case update_couple_profile = "update-couple-profile"
    case get_business_restaurants = "get-business-restaurants"

}

//MARK: - endpoint extension for url -
extension EndPoints {
    
    var url: String {
        
        switch self {
        case .BASE_URL:
            return self.rawValue
        default:
            let tmpString = "\(EndPoints.BASE_URL.rawValue)\(self.rawValue)"
            return tmpString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
    }
}
