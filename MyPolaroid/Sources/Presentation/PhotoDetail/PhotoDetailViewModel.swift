//
//  PhotoDetailViewModel.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/27/24.
//

import Foundation

class PhotoDetailViewModel {
    var inputPhoto: Observable<Photo?> = Observable(nil)
    
    var outputIsFavorite: Observable<Bool> = Observable(false)
    var outputViewsCount: Observable<String> = Observable("0")
    var outputDownloadsCount: Observable<String> = Observable("0")
    
    private let realmManager = RealmManager()
    
    func setPhoto(_ photo: Photo) {
        self.inputPhoto.value = photo
        fetchStatistics(for: photo.id)
        checkFavorite(photo)
    }
    
    private func fetchStatistics(for imageID: String) {
        UnsplashAPIManager.shared.fetchPhotoStatistics(imageID: imageID) { [weak self] statistics in
            guard let self = self, let statistics = statistics else { return }
            DispatchQueue.main.async {
                self.outputViewsCount.value = "\(statistics.views.total)"
                self.outputDownloadsCount.value = "\(statistics.downloads.total)"
            }
        }
    }
    
    private func checkFavorite(_ photo: Photo) {
        let isFavorited = realmManager.isFavoritePhoto(url: photo.urls.raw)
        self.outputIsFavorite.value = isFavorited
    }
    
    func toggleFavorite() {
        guard let photo = inputPhoto.value else { return }
        if outputIsFavorite.value {
            realmManager.deleteFavoritePhoto(url: photo.urls.raw)
        } else {
            realmManager.createFavoritePhoto(url: photo.urls.raw)
        }
        outputIsFavorite.value.toggle()
    }
}
