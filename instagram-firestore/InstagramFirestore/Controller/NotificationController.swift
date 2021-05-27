//
//  NotificationController.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 03/05/21.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    //MARK: - Properties
    
    private let refresher = UIRefreshControl()
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNotifications()
    }
    
    //MARK: - Actions
    
    @objc func handleRefreshControl() {
        notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
    
    //MARK: - API
    
    func fetchNotifications() {
        NotificationService.fetchNotification { (notifications) in
            self.notifications = notifications
            self.isUserFollowed()
        }
    }
    
    func isUserFollowed() {
        notifications.forEach { (notification) in
            UserService.isUserFollowed(uid: notification.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}) {
                    self.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        refresher.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    
}

//MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        UserService.fetchUser(withUid: notifications[indexPath.row].uid) { user in
            self.showLoader(false)
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


extension NotificationController: NotificationCellDelegate {
    func cell(_ cell: NotificationCell, tapFollow uid: String) {
        showLoader(true)
        UserService.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, tapUnfollow uid: String) {
        showLoader(true)
        UserService.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
            
        }
    }
    
    func cell(_ cell: NotificationCell, tapPost postId: String) {
        showLoader(true)
        PostService.fetchPost(withPostId: postId) { post in
            self.showLoader(false)
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}
