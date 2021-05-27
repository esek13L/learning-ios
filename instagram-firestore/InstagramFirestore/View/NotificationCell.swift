//
//  NotificationCell.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 24/05/21.
//

import UIKit

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, tapFollow uid: String)
    func cell(_ cell: NotificationCell, tapUnfollow uid: String)
    func cell(_ cell: NotificationCell, tapPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    //MARK: - Properties
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
       return iv
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 48, width: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        contentView.addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 100, height: 32)
        
        contentView.addSubview(infoLabel)
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 4)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
        
        contentView.addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, tapUnfollow: viewModel.userId)
        } else {
            delegate?.cell(self, tapFollow: viewModel.userId)
        }
    }
    
    @objc func handlePostTapped() {
        guard let postId = viewModel?.postId else { return }
        delegate?.cell(self, tapPost: postId)
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        infoLabel.attributedText = viewModel.notificationMessage
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        
        postImageView.isHidden = viewModel.isFollowingType
        followButton.isHidden = !viewModel.isFollowingType
        followButton.setTitle(viewModel.followText, for: .normal)
        followButton.setTitleColor(viewModel.followTextColor, for: .normal)
        followButton.backgroundColor = viewModel.followBackgroundColor
    }

    
}
