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
    private let headerView = FavoriteFilteredHeaderView()
    private var favoritePhotos: Results<FavoritePhotoTable>?
    private let realmManager = RealmManager()
    private let noDataLabel = UILabel()
    private var isSortedByLatest = true // 최신순 정렬 여부를 나타내는 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavoritePhotos()
        notificationObserver()
    }
    
    override func configureNavigation() {
        navigationItem.title = "MY POLAROID"
    }
    
    override func configureHierarchy() {
        view.addSubviews(headerView, collectionView, noDataLabel)
    }
    
    override func configureUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        noDataLabel.text = "저장된 사진이 없어요."
        noDataLabel.textAlignment = .center
        noDataLabel.font = .boldSystemFont(ofSize: 18)
        noDataLabel.textColor = .black
        noDataLabel.isHidden = true

        headerView.onSortButtonTapped = { [weak self] in
            self?.sortFavoritePhotos()
        }
    }
    
    override func configureConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        noDataLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func notificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadFavoritePhotos), name: RealmManager.favoriteChangedNotification, object: nil)
    }
    
    @objc private func loadFavoritePhotos() {
        favoritePhotos = realmManager.getAllFavoritePhotos()
        sortAndReloadData()
    }
    
    private func sortAndReloadData() {
        if isSortedByLatest {
            favoritePhotos = favoritePhotos?.sorted(byKeyPath: "createdAt", ascending: false)
            headerView.sortedButton.setTitle("최신순", for: .normal)
        } else {
            favoritePhotos = favoritePhotos?.sorted(byKeyPath: "createdAt", ascending: true)
            headerView.sortedButton.setTitle("과거순", for: .normal)
        }
        collectionView.reloadData()
        noDataLabel.isHidden = !(favoritePhotos?.isEmpty ?? true)
    }
    
    private func sortFavoritePhotos() {
        let alert = UIAlertController(title: nil, message: "정렬 방식을 선택하세요", preferredStyle: .actionSheet)
        let latestAction = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.isSortedByLatest = true
            self?.sortAndReloadData()
        }
        let oldestAction = UIAlertAction(title: "과거순", style: .default) { [weak self] _ in
            self?.isSortedByLatest = false
            self?.sortAndReloadData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(latestAction)
        alert.addAction(oldestAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
