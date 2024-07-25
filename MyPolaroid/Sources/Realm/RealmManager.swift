//
//  RealmManager.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import RealmSwift
import UIKit

final class RealmManager {
    private let realm = try! Realm()
    static let favoriteChangedNotification = Notification.Name("favoriteChangedNotification")
    
    func createFavoritePhoto(url: String) {
        let favoritePhoto = FavoritePhotoTable(url: url)
        try! realm.write {
            realm.add(favoritePhoto)
        }
        NotificationCenter.default.post(name: RealmManager.favoriteChangedNotification, object: nil)
    }
    
    func deleteFavoritePhoto(url: String) {
        if let photo = realm.objects(FavoritePhotoTable.self).filter("url == %@", url).first {
            try! realm.write {
                realm.delete(photo)
            }
            NotificationCenter.default.post(name: RealmManager.favoriteChangedNotification, object: nil)
        }
    }
    
    func isFavoritePhoto(url: String) -> Bool {
        return realm.objects(FavoritePhotoTable.self).filter("url == %@", url).first != nil
    }
    
    func getAllFavoritePhotos() -> Results<FavoritePhotoTable> {
        return realm.objects(FavoritePhotoTable.self)
    }
}
