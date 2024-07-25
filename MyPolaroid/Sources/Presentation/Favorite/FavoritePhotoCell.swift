//
//  FavoritePhotoCell.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class FavoritePhotoCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let likesContainer = UIView()
    private let likesLabel = UILabel()
    private let favoriteButton = UIButton()
    private var photoUrl: String?
    private var isFavorited = false {
        didSet {
            updateFavoriteButtonState()
        }
    }
    private let realmManager = RealmManager()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(likesContainer)
        contentView.addSubview(favoriteButton)
        likesContainer.addSubview(likesLabel)
    }
    
    override func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        likesContainer.backgroundColor = .gray
        likesContainer.layer.cornerRadius = 10
        likesContainer.layer.masksToBounds = true
        
        likesLabel.textColor = .white
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textAlignment = .center
        
        favoriteButton.setImage(UIImage(named: "like_circle_inactive"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likesContainer.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.height.equalTo(24)
            make.width.equalTo(70)
        }
        likesLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.size.equalTo(30)
        }
    }
    
    func configure(with url: String) {
        if let url = URL(string: url) {
            imageView.kf.setImage(with: url)
            photoUrl = url.absoluteString
            isFavorited = realmManager.isFavoritePhoto(url: url.absoluteString)
        }
    }
    
    private func updateFavoriteButtonState() {
        let imageName = isFavorited ? "like_circle" : "like_circle_inactive"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let url = photoUrl else { return }
        isFavorited.toggle()
        if isFavorited {
            realmManager.createFavoritePhoto(url: url)
        } else {
            realmManager.deleteFavoritePhoto(url: url)
        }
    }
}
