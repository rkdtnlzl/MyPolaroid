//
//  PhotoCollectionViewCell.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/24/24.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView()
    let likesContainer = UIView()
    let likesLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(likesContainer)
        likesContainer.addSubview(likesLabel)
    }
    
    override func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        likesContainer.backgroundColor = MPColors.gray
        likesContainer.layer.cornerRadius = 10
        
        likesLabel.textColor = .white
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textAlignment = .center
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
    }
    
    func configure(with photo: Photo) {
        if let url = URL(string: photo.urls.small) {
            imageView.kf.setImage(with: url)
        }
        likesLabel.text = "⭐️ \(photo.likes)"
    }
}
