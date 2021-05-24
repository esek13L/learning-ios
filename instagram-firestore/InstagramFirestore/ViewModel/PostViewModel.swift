//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 21/05/21.
//

import Foundation

struct PostViewModel {
    
    let post: Posts
    
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
    
    init(post: Posts) {
        self.post = post
    }
}
