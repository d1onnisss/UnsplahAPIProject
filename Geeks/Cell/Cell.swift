//
//  Cell.swift
//  Geeks
//
//  Created by Alexey Lim on 14/8/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected) 
        button.tintColor = .red
        button.contentMode = .center
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private var photo: UnsplashPhoto?
    private var isLiked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(8)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with photo: UnsplashPhoto) {
        if let url = URL(string: photo.urls.regular) {
            imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))])
        } else {
            imageView.image = nil
        }
        self.photo = photo
        self.isLiked = false
        likeButton.isSelected = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        likeButton.isSelected = false
    }
    
    @objc private func didTapLike() {
        isLiked.toggle()
        likeButton.isSelected = isLiked

        guard let photo = photo else { return }
        let tabBarVC = UIApplication.shared.windows.first?.rootViewController as? TabBarController
        let favoritesVC = tabBarVC?.viewControllers?[1].children.first as? FavoritesViewController
        
        if isLiked {
            favoritesVC?.addFavorite(photo: photo)
        } else {
            favoritesVC?.removeFavorite(photo: photo)
        }
    }
}
