//
//  CommentCell.swift
//  InstagramFirestore
//
//  Created by Esekiel Surbakti on 21/05/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    var viewModel: CommentViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let commentLabelText: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.setDimensions(height: 36, width: 36)
        profileImageView.layer.cornerRadius = 36 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        
        addSubview(commentLabelText)
        commentLabelText.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 6)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        commentLabelText.attributedText = viewModel.commentLabelText()
    }
}
