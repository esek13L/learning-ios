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
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date())
    }
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: username, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "  \(timestampString ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    var isFollowingType: Bool { return notification.type == .follow }
    var followText: String { return notification.userIsFollowed ? "Following" : "Follow" }
    var followBackgroundColor: UIColor { return notification.userIsFollowed ? .white : .systemBlue}
    var followTextColor: UIColor { return notification.userIsFollowed ? .black : .white }
    var userId: String { return notification.uid }
}
