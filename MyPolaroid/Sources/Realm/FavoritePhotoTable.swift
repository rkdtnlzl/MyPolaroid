//
//  FavoritePhotoTable.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/25/24.
//

import RealmSwift

class FavoritePhotoTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var url: String = ""
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }
}
