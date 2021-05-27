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
            
            let docRef = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            
            self.updateUserFeedAfterPost(postId: docRef.documentID)
            
        }
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Posts) -> Void) {
        COLLECTION_POSTS.document(postId).getDocument { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post  = Posts(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }
    
    static func fetchFeedPosts(completion: @escaping([Posts]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Posts]()
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                fetchPost(withPostId: document.documentID) { post in
                    posts.append(post)
                    
                    posts.sort(by: { $0.timestamp.seconds > $1.timestamp.seconds })
                    completion(posts)
                }
            })
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
            var posts = documents.map({Posts(postId: $0.documentID, dictionary: $0.data())})
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
    }
    
    static func likePost(post: Posts, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unlikePost(post: Posts, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else  { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete() { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId)
                .delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Posts, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, _) in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            let docIDs = documents.map({ $0.documentID })
            
            docIDs.forEach { id in
                if didFollow {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).setData([:])
                } else {
                    COLLECTION_USERS.document(uid).collection("user-feed").document(id).delete()
                }
                
            }
        }
    }
    
    private static func updateUserFeedAfterPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { (document) in
                COLLECTION_USERS.document(document.documentID).collection("user-feed").document(postId)
                    .setData([:])
            }
            
            COLLECTION_USERS.document(uid).collection("user-feed").document(postId).setData([:])
            
        }
    }
}
