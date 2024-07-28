//
//  FavoritePhotoTable.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import RealmSwift
import Foundation

class FavoritePhotoTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var url: String = ""
    @Persisted var createdAt: Date = Date()
    
    convenience init(url: String) {
        self.init()
        self.url = url
        self.createdAt = Date()
    }
}
