//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 21/05/21.
//

import UIKit

struct PostViewModel {
    
    var post: Posts
    
    var caption: String { return post.caption }
    var likes: String {
        if post.likes != 1 {
            return "\(post.likes) likes"
        } else {
            return "\(post.likes) like"
        }
    }
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    var ownerUsername: String { return post.ownerUsername }
    var ownerImageUrl: URL? { return URL(string: post.ownerImageUrl)}
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .blue
    }
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: post.timestamp.dateValue(), to: Date())
    }
    
    
    init(post: Posts) {
        self.post = post
    }
}
