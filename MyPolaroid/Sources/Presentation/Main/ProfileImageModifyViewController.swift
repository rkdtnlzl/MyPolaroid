//
//  ProfileImageModifyViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/28/24.
//

import UIKit
import SnapKit

final class ProfileImageModifyViewController: BaseViewController, UICollectionViewDelegateFlowLayout {
    
    private let profileImageView = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    private let imageNames = (0...11).map { "profile_\($0)" }
    var selectedIndexPath: IndexPath?
    var selectedImage: UIImage?
    var onSelectImage: ((Int) -> Void)?
    
    override func configureNavigation() {
        navigationItem.title = StringLiterals.NavigationTitle.profileSetting
    }
    
    override func configureHierarchy() {
        view.addSubviews(profileImageView, collectionView)
    }
    
    override func configureUI() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = MPColors.blue.cgColor
        profileImageView.clipsToBounds = true
        
        let profileNumber = UserDefaults.standard.integer(forKey: "\(UserDefaultsKey.profileNumberKey)")
        profileImageView.image = UIImage(named: "profile_\(profileNumber)")
        selectedIndexPath = IndexPath(item: profileNumber, section: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        
        collectionView.backgroundColor = .white
    }
    
    override func configureConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 80, height: 80)
        return layout
    }
}

extension ProfileImageModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath)
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(image: UIImage(named: imageNames[indexPath.item]))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = cell.contentView.bounds
        imageView.clipsToBounds = true
        cell.contentView.addSubview(imageView)
        cell.layer.cornerRadius = 40
        cell.clipsToBounds = true
        if selectedIndexPath == indexPath {
            cell.layer.borderColor = MPColors.blue.cgColor
            cell.layer.borderWidth = 5
            cell.contentView.alpha = 1.0
        } else {
            cell.layer.borderColor = MPColors.gray.cgColor
            cell.layer.borderWidth = 1
            cell.contentView.alpha = 0.5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        profileImageView.image = UIImage(named: imageNames[indexPath.item])
        UserDefaults.standard.set(indexPath.item, forKey: "\(UserDefaultsKey.profileNumberKey)")
        onSelectImage?(indexPath.item)
        collectionView.reloadData()
//        navigationController?.popViewController(animated: true)
    }
}
