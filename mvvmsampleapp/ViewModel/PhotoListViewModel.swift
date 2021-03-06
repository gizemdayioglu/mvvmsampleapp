//
//  PhotoListViewModel.swift
//  mvvmsampleapp
//
//  Created by Gizem Gulsen on 7/16/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import Foundation

class PhotoListViewModel {

    let apiService: ServiceManagerProtocol

    private var photos: [Photo] = [Photo]()
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var numberOfCells: Int {
        return cellViewModels.count
    }

    var isAllowSegue: Bool = false
    var selectedPhoto: Photo?

    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?

    init( apiService: ServiceManagerProtocol = ServiceManager()) {
        self.apiService = apiService
    }

    func initFetch() {
        self.isLoading = true
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else if success {
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }

    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }

    func createCellViewModel( photo: Photo ) -> PhotoListCellViewModel {

        var descTextContainer: [String] = [String]()
        if let camera = photo.camera {
            descTextContainer.append(camera)
        }

        if let description = photo.description {
            descTextContainer.append( description )
        }

        let desc = descTextContainer.joined(separator: " - ")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return PhotoListCellViewModel( titleText: photo.name,
                                       descText: desc,
                                       imageUrl: photo.imageUrl,
                                       dateText: dateFormatter.string(from: photo.createdAt) )
    }

    private func processFetchedPhoto( photos: [Photo] ) {
        self.photos = photos // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append( createCellViewModel(photo: photo) )
        }
        self.cellViewModels = vms
    }

}

extension PhotoListViewModel {
    func userPressed( at indexPath: IndexPath ) {
        let photo = self.photos[indexPath.row]
        if photo.forSale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        } else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.alertMessage = self.showAlertMessage(photo: photo)
        }
    }

    func showAlertMessage(photo: Photo) -> String {
        return "\(photo.name) is not available for sale!"
    }
}

struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
