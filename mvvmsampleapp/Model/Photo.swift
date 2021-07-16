//
//  Photo.swift
//  mvvmsampleapp
//
//  Created by Gizem Gulsen on 7/16/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import Foundation
struct Photos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let photoId: Int
    let name: String
    let description: String?
    let createdAt: Date
    let imageUrl: String
    let forSale: Bool
    let camera: String?
}
