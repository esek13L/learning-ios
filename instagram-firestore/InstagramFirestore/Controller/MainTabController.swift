//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 03/05/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    private var user: User? {
        didSet {
            guard let user = user else {
                return
            }
            
            initViewController(withUser: user)
        }
    }
    
    // MARK: - Lifecycke
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isUserLoggedIn()
        fetchUsers()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.fetchCurrentUser { user in
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    func initViewController(withUser user: User) {
        view.backgroundColor = .white
        
        let feedLayout = UICollectionViewFlowLayout()
        let feed = setupNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootVC: FeedController(collectionViewLayout: feedLayout))
        
        let search = setupNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootVC: SearchController())
        let imageSelector = setupNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootVC: ImageSelectorController())
        let notifications = setupNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootVC: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = setupNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootVC: profileController)
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        tabBar.tintColor = .black
        
    }
    
    func setupNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootVC: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootVC)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func isUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUsers()
        self.dismiss(animated: true, completion: nil)
    }
}
