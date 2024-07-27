//
//  PhotoStatistics.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/27/24.
//

import Foundation

struct PhotoStatistics: Decodable {
    let views: Count
    let downloads: Count
    
    struct Count: Decodable {
        let total: Int
    }
}
