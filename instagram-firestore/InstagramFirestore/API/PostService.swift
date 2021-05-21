//
//  PostService.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 21/05/21.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(user: User?, caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        
        guard let user = user else { return }
        
        ImageUploader.uploadImage(image: image) { (imageUrl) in
            let data = ["caption": caption,
                        "timestamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.username,
                        "ownerUid":user.uid] as [String: Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
        }
    }
    
    static func fetchPosts(completion: @escaping([Posts]) -> Void) {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let posts = documents.map({ Posts(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }
    
    static func fetchCurrentUserPosts(uid: String, completion: @escaping([Posts]) -> Void) {
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
           
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            print("Documents: \(documents)")
            
            let posts = documents.map({Posts(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }
}
