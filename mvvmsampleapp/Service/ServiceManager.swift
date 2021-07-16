//
//  ServiceManager.swift
//  mvvmsampleapp
//
//  Created by Gizem Gulsen on 7/16/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol ServiceManagerProtocol {
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo],
        _ error: APIError? ) -> Void )
}

class ServiceManager: ServiceManagerProtocol {
    func fetchPopularPhoto( complete: @escaping ( _ success: Bool, _ photos: [Photo],
        _ error: APIError? ) -> Void ) {
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let photos = try decoder.decode(Photos.self, from: data)
                complete( true, photos.photos, nil )
            } catch {
                print("Error")
            }
        }
    }
}
