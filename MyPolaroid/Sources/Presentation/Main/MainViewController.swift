//
//  MainViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit

final class MainViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let sectionTitles = ["골든 아워", "건축 및 인테리어", "비즈니스 업무"]
    private let apiURLs = [
        APIURL.goldenHourURL,
        APIURL.architectureURL,
        APIURL.businessURL
    ]
    private var collectionViews: [UICollectionView] = []
    private var photosData: [[Photo]] = [[], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        fetchData()
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
    }
    
    override func configureUI() {
        titleLabel.text = "OUR TOPIC"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .black
    }
    
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView).inset(20)
        }
    }
    
    private func setupCollectionViews() {
        for i in 0..<apiURLs.count {
            let sectionLabel = UILabel()
            sectionLabel.text = sectionTitles[i]
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 20)
            contentView.addSubview(sectionLabel)

            let topAnchor: ConstraintItem
            if i == 0 {
                topAnchor = titleLabel.snp.bottom
            } else {
                topAnchor = collectionViews[i-1].snp.bottom
            }
            
            sectionLabel.snp.makeConstraints { make in
                make.top.equalTo(topAnchor).offset(30)
                make.leading.equalToSuperview().inset(20)
            }
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 200, height: 250)
            layout.minimumLineSpacing = 10
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.id)
            contentView.addSubview(collectionView)
            collectionViews.append(collectionView)
            
            collectionView.snp.makeConstraints { make in
                make.top.equalTo(sectionLabel.snp.bottom).offset(10)
                make.leading.equalToSuperview().inset(10)
                make.trailing.equalToSuperview()
                make.height.equalTo(250)
                if i == apiURLs.count - 1 {
                    make.bottom.equalToSuperview().inset(16)
                }
            }
        }
    }

    
    private func fetchData() {
        for (index, urlString) in apiURLs.enumerated() {
            UnsplashAPIManager.shared.fetchPhotos(urlString: urlString) { [weak self] photos in
                guard let self = self else { return }
                if let photos = photos {
                    self.photosData[index] = photos
                    self.collectionViews[index].reloadData()
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let index = collectionViews.firstIndex(of: collectionView) {
            return photosData[index].count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.id, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let index = collectionViews.firstIndex(of: collectionView) {
            let photo = photosData[index][indexPath.row]
            cell.configure(with: photo)
        }
        return cell
    }
}
