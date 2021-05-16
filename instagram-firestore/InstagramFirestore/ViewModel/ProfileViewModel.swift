//
//  ProfileViewModel.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 15/05/21.
//

import Foundation

struct ProfileViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    
    init(user: User) {
        self.user = user
    }
}
