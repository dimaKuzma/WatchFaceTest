//
//  Document.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import ZIPFoundation

class Document: UIDocument {
    var watchface: Watchface? = .init(
        photosWatchface: PhotosWatchface(
            device_size: 2, position: .top, snapshot: Data(), no_borders_snapshot: Data(), topComplication: nil, bottomComplication: nil, resources: .init(images: .init(imageList: []), files: [:])))
    private var isLossyReading = false
    private var allowLossyAutosaving = false
    var fileWrapper: FileWrapper?
    
    
    override func read(from url: URL) throws {
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
        try FileManager.default.unzipItem(at: url, to: tmpURL)
        defer {try? FileManager.default.removeItem(at: tmpURL)}
        try read(from: tmpURL)
    }
    
    
    override func contents(forType typeName: String) throws -> Any {
        let fw = try FileWrapper(watchface: watchface!)
        let tmpFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
        defer {try? FileManager.default.removeItem(at: tmpFolderURL)}
        try fw.write(to: tmpFolderURL, options: [], originalContentsURL: nil)
        let tmpZipURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(ProcessInfo.processInfo.globallyUniqueString)
        defer {try? FileManager.default.removeItem(at: tmpZipURL)}
        try FileManager.default.zipItem(at: tmpFolderURL, to: tmpZipURL, shouldKeepParent: false)
        return try Data(contentsOf: tmpZipURL)
    }
    
    private func encodeToWrapper(object: NSCoding) -> FileWrapper {
        let archiver = NSKeyedArchiver(requiringSecureCoding: false)
        archiver.encode(object, forKey: "Data")
        archiver.finishEncoding()
        return FileWrapper(regularFileWithContents: archiver.encodedData)
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? FileWrapper else { return }
        fileWrapper = contents
    }
    
    func decodeFromWrapper(for name: String) -> Any? {
        guard let allWrappers = fileWrapper,
            let wrapper = allWrappers.fileWrappers?[name],
            let data = wrapper.regularFileContents else { return nil }
        do {
            let unarchiver = try NSKeyedUnarchiver.init(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            return unarchiver.decodeObject(forKey: "Data")
        } catch let error {
            fatalError("Unarchiving failed. \(error.localizedDescription)")
        }
    }
}
