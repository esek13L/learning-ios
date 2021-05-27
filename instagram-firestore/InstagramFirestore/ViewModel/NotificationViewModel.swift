//
//  NotificationViewModel.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 25/05/21.
//

import Firebase
import UIKit

struct NotificationViewModel {
    
     var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postId: String? { return notification.postId }
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "") }
    var userProfileImageUrl: URL? { return URL(string: notification.userProfileImageUrl)}
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "  2m", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    var isFollowingType: Bool { return notification.type == .follow }
    var followText: String { return notification.userIsFollowed ? "Following" : "Follow" }
    var followBackgroundColor: UIColor { return notification.userIsFollowed ? .white : .systemBlue}
    var followTextColor: UIColor { return notification.userIsFollowed ? .black : .white }
    var userId: String { return notification.uid }
}
