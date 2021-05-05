//
//  ImageItemRowView.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import Ikemen

final class ImageItemRowView: UITableRowView {
    private let titleLabel = NSTextField(labelWithString: "")
    private let imageView = EditableImageView()
    private var imageViewAspectConstraint: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            imageViewAspectConstraint?.isActive = true
        }
    }
    private let movieView = EditableAVPlayerView()
    var imageDidChange: ((UIImage?) -> Void)?
    var movieDidChange: (((data: Data, duration: Double?)?) -> Void)?

    struct ImageItem: Equatable {
        static func == (lhs: ImageItemRowView.ImageItem, rhs: ImageItemRowView.ImageItem) -> Bool {
            lhs.image?.tiffRepresentation == rhs.image?.tiffRepresentation
                && lhs.movie?.data == rhs.movie?.data
                && lhs.movie?.duration == rhs.movie?.duration
        }
        
        var image: UIImage?
        var movie: (data: Data, duration: Double?)?
    }

    var item: ImageItem {
        didSet {
            reloadItem()
        }
    }

    init(item: ImageItem) {
        self.item = item
        super.init(frame: .zero)

        let autolayout = northLayoutFormat([:], [
            "title": titleLabel,
            "image": imageView ※ {
                $0.imageDidChange = { [weak self] in
                    self?.item.image = $0
                    self?.imageDidChange?($0)
                }
            },
            "movie": movieView ※ { movieView in
                movieView.movieDidChange = { [weak self] in
                    self?.item.movie = $0.map {($0.data, $0.duration)}
                    self?.movieDidChange?(self?.item.movie)
                }
            },
        ])
        autolayout("H:|-[title]-|") // typically "384x480" (38mm)
        autolayout("H:|-[image]-[movie(image)]|")
        autolayout("V:|-[title]-[image(240)]-|")
        autolayout("V:|-[title]-[movie(image)]-|")

        reloadItem()
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    private func reloadItem() {
        titleLabel.stringValue = [
            item.image.map {"\(Int($0.size.width))×\(Int($0.size.height))"} ?? "no image",
            item.movie != nil ? "Live Photo" : "Single (not a Live Photo)"
        ].joined(separator: ", ")

        if imageView.image != item.image {
            imageView.image = item.image
        }
        imageViewAspectConstraint = item.image.map { image in
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
        }

        if movieView.data != item.movie?.data {
            movieView.movie = item.movie.map {.init(data: $0.data, duration: $0.duration)}
        }
        movieView.controlsStyle = item.movie != nil ? .minimal : .none
    }
}
