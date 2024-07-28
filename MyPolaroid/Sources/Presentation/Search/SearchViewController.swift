//
//  SearchViewController.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import UIKit
import SnapKit
import RealmSwift

final class SearchViewController: BaseViewController {
    private var photos: [Photo] = []
    private var currentPage = 1
    private var isLoading = false
    private var currentQuery = ""
    private var currentOrderBy: OrderBy = .relevance
    private let searchBar = UISearchBar()
    private let headerView = SearchFilteredHeaderView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SearchPhotoCell.self, forCellWithReuseIdentifier: SearchPhotoCell.identifier)
        return collectionView
    }()
    private let noResultsLabel = UILabel()
    private let startLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelsVisibility()
        configureHeaderActions()
        print("\(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    override func configureNavigation() {
        navigationItem.title = "SEARCH PHOTO"
    }
    
    override func configureHierarchy() {
        view.addSubviews(searchBar, headerView, collectionView, noResultsLabel, startLabel)
    }
    
    override func configureUI() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        noResultsLabel.text = "검색결과가 없어요."
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = .boldSystemFont(ofSize: 18)
        noResultsLabel.textColor = .black
        noResultsLabel.isHidden = true
        
        startLabel.text = "사진을 검색해보세요."
        startLabel.textAlignment = .center
        startLabel.font = .boldSystemFont(ofSize: 18)
        startLabel.textColor = .black
        startLabel.isHidden = true
    }
    
    override func configureConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        noResultsLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        startLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetchPhotos(query: String, page: Int) {
        guard !isLoading else { return }
        isLoading = true
        UnsplashAPIManager.shared.fetchSearchPhotos(query: query, page: page, orderBy: currentOrderBy) { [weak self] photos in
            guard let self = self else { return }
            self.isLoading = false
            if let photos = photos {
                if page == 1 {
                    self.photos = photos
                } else {
                    self.photos.append(contentsOf: photos)
                }
                DispatchQueue.main.async {
                    self.updateLabelsVisibility()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    private func resetSearch() {
        currentPage = 1
        photos = []
        collectionView.reloadData()
        updateLabelsVisibility()
    }
    
    private func updateLabelsVisibility() {
        if currentQuery.isEmpty {
            startLabel.isHidden = false
            noResultsLabel.isHidden = true
        } else if photos.isEmpty {
            startLabel.isHidden = true
            noResultsLabel.isHidden = false
        } else {
            startLabel.isHidden = true
            noResultsLabel.isHidden = true
        }
    }
    
    private func configureHeaderActions() {
        headerView.onSortButtonTapped = { [weak self] in
            self?.presentSortOptions()
        }
    }
    
    private func presentSortOptions() {
        let alert = UIAlertController(title: nil, message: "정렬 방식을 선택하세요", preferredStyle: .actionSheet)
        let relevanceAction = UIAlertAction(title: "관련순", style: .default) { [weak self] _ in
            self?.headerView.sortedButton.setTitle("관련순", for: .normal)
            self?.currentOrderBy = .relevance
            self?.resetSearch()
            self?.fetchPhotos(query: self?.currentQuery ?? "", page: self?.currentPage ?? 1)
        }
        let latestAction = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.headerView.sortedButton.setTitle("최신순", for: .normal)
            self?.currentOrderBy = .latest
            self?.resetSearch()
            self?.fetchPhotos(query: self?.currentQuery ?? "", page: self?.currentPage ?? 1)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(relevanceAction)
        alert.addAction(latestAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentQuery = searchText
        resetSearch()
        if searchText.isEmpty {
            updateLabelsVisibility()
        } else {
            fetchPhotos(query: currentQuery, page: currentPage)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPhotoCell.identifier, for: indexPath) as? SearchPhotoCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.item]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 4) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        let detailViewController = PhotoDetailViewController()
        detailViewController.photo = photo
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            currentPage += 1
            fetchPhotos(query: currentQuery, page: currentPage)
        }
    }
}
