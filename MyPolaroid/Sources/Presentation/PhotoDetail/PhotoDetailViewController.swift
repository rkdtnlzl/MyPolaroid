//
//  PhotoDetailViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/27/24.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoDetailViewController: BaseViewController {
    
    private let imageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let createAtLabel = UILabel()
    private let favoriteButton = UIButton()
    private var isFavorited: Bool = false
    private let infoTitle = UILabel()
    private let sizeTitle = UILabel()
    private let sizeLabel = UILabel()
    private let viewsTitle = UILabel()
    private let viewsLabel = UILabel()
    private let downloadsTitle = UILabel()
    private let downloadsLabel = UILabel()
    var photo: Photo? {
        didSet {
            configureData()
            updateFavoriteButtonState()
            fetchStatistics()
        }
    }
    
    override func configureHierarchy() {
        view.addSubviews(imageView, userNameLabel, userProfileImageView, createAtLabel, favoriteButton, infoTitle, sizeTitle, sizeLabel, viewsTitle, viewsLabel, downloadsTitle, downloadsLabel)
    }
    
    override func configureUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        userNameLabel.font = .systemFont(ofSize: 15)
        userNameLabel.textColor = .black
        
        createAtLabel.font = .boldSystemFont(ofSize: 15)
        createAtLabel.textColor = .black
        
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.layer.cornerRadius = 25
        userProfileImageView.clipsToBounds = true
        
        favoriteButton.backgroundColor = MPColors.lightGray
        favoriteButton.layer.cornerRadius = 20
        
        infoTitle.font = .boldSystemFont(ofSize: 16)
        infoTitle.text = "정보"
        infoTitle.textColor = .black
        
        sizeTitle.font = .boldSystemFont(ofSize: 14)
        sizeTitle.text = "크기"
        sizeTitle.textColor = .black
        
        sizeLabel.font = .systemFont(ofSize: 14)
        sizeLabel.textColor = .black
        
        viewsTitle.font = .boldSystemFont(ofSize: 14)
        viewsTitle.text = "조회수"
        viewsTitle.textColor = .black
        
        viewsLabel.font = .systemFont(ofSize: 14)
        viewsLabel.textColor = .black
        
        downloadsTitle.font = .boldSystemFont(ofSize: 14)
        downloadsTitle.text = "다운로드"
        downloadsTitle.textColor = .black
        
        downloadsLabel.font = .systemFont(ofSize: 14)
        downloadsLabel.textColor = .black
    }
    
    override func configureTarget() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func favoriteButtonTapped() {
        guard let photo = photo else { return }
        if isFavorited {
            RealmManager().deleteFavoritePhoto(url: photo.urls.raw)
        } else {
            RealmManager().createFavoritePhoto(url: photo.urls.raw)
        }
        isFavorited.toggle()
        updateFavoriteButtonState()
    }
    
    override func configureConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.width.height.equalTo(50)
        }
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
        }
        createAtLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
            make.width.height.equalTo(40)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
        }
        sizeTitle.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.leading.equalTo(infoTitle.snp.trailing).offset(60)
        }
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        viewsTitle.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.leading.equalTo(infoTitle.snp.trailing).offset(60)
        }
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        downloadsTitle.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(10)
            make.leading.equalTo(infoTitle.snp.trailing).offset(60)
        }
        downloadsLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureData() {
        if let photo = photo {
            if let url = URL(string: photo.urls.raw) {
                imageView.kf.setImage(with: url)
            }
            userNameLabel.text = photo.user.username
            createAtLabel.text = photo.createdAt
            sizeLabel.text = "\(photo.width) * \(photo.height)"
            if let profileImageURL = URL(string: photo.user.profileImage.small) {
                userProfileImageView.kf.setImage(with: profileImageURL)
            }
            isFavorited = RealmManager().isFavoritePhoto(url: photo.urls.raw)
            updateFavoriteButtonState()
        }
    }
    
    private func fetchStatistics() {
        guard let photo = photo else { return }
        UnsplashAPIManager.shared.fetchPhotoStatistics(imageID: photo.id) { [weak self] statistics in
            guard let self = self, let statistics = statistics else { return }
            DispatchQueue.main.async {
                self.viewsLabel.text = "\(statistics.views.total)"
                self.downloadsLabel.text = "\(statistics.downloads.total)"
            }
        }
    }
    
    private func updateFavoriteButtonState() {
        let imageName = isFavorited ? "like_circle" : "like_circle_inactive"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
