//
//  Posts.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 21/05/21.
//

import Foundation
import Firebase

struct Posts {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let ownerUsername: String
    let ownerImageUrl: String
    let timestamp: Timestamp!
    let postId: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp
        self.postId = postId
    }
}
