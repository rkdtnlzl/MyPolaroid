//
//  FavoriteViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit
import RealmSwift

final class FavoriteViewController: BaseViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(FavoritePhotoCell.self, forCellWithReuseIdentifier: FavoritePhotoCell.identifier)
        return collectionView
    }()
    private var favoritePhotos: Results<FavoritePhotoTable>?
    private let realmManager = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoritePhotos()
        notificationObserver()
    }
    
    override func configureNavigation() {
        navigationItem.title = "MY POLAROID"
    }
    
    override func configureHierarchy() {
        view.addSubviews(collectionView)
    }
    
    override func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func notificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavoritePhotos), name: RealmManager.favoriteChangedNotification, object: nil)
    }
    
    @objc private func loadFavoritePhotos() {
        favoritePhotos = realmManager.getAllFavoritePhotos()
        collectionView.reloadData()
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritePhotoCell.identifier, for: indexPath) as? FavoritePhotoCell else {
            return UICollectionViewCell()
        }
        if let photo = favoritePhotos?[indexPath.item] {
            cell.configure(with: photo.url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 8) / 2
        return CGSize(width: width, height: width)
    }
}
