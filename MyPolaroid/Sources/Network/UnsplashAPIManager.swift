//
//  NetworkManager.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/24/24.
//

import Foundation
import Alamofire

class UnsplashAPIManager {
    static let shared = UnsplashAPIManager()
    
    func fetchPhotos(urlString: String, completion: @escaping ([Photo]?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        AF.request(url).responseData { response in
            guard let data = response.data else {
                completion(nil)
                return
            }
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }
    
    func fetchSearchPhotos(query: String, page: Int, completion: @escaping ([SearchPhoto]?) -> Void) {
        let urlString = "\(APIURL.searchPhotoURL)&query=\(query)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let photoResponse = try JSONDecoder().decode(SearchPhotoResponse.self, from: data)
                    completion(photoResponse.results)
                } catch {
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
