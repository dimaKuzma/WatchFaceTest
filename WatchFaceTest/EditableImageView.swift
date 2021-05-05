//
//  EditableImageView.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

#if !os(iOS)
import Cocoa
#endif
import NorthLayout

final class EditableImageView: UIView {
    private let imageView = UIImageView()
    let openButton = NSButton(title: "Open...", target: nil, action: nil)
    
    var image: UIImage? {
        get {imageView.image}
        set {
            imageView.image = newValue
            openButton.isHidden = newValue != nil
        }
    }
    
    var imageDidChange: ((UIImage?) -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
            
        imageView.imageFrameStyle = .photo
        imageView.isEditable = true
        imageView.target = self
        imageView.action = #selector(imageViewDidChangeValue(_:))
        openButton.target = self
        openButton.action = #selector(open(_:))
        
        let autolayout = northLayoutFormat([:], ["image": imageView, "open": openButton])
        autolayout("H:|[image]|")
        autolayout("V:|[image]|")
        openButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        openButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(openButton, positioned: .above, relativeTo: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func imageViewDidChangeValue(_ sender: Any?) {
        imageDidChange?(imageView.image)
    }
    
    @IBAction func open(_ sender: Any?) {
        guard let window = window else { return }
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        if #available(OSX 11.0, *) {
            panel.allowedFileTypes = ["png"]
        } else {
            panel.allowedFileTypes = ["png", "jpeg", "jpg"]
        }
        panel.beginSheetModal(for: window) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .OK:
                guard let url = panel.url, let image = NSImage(contentsOf: url) else { return }
                self.image = image
                self.imageDidChange?(image)
            case .abort:
                break
            default:
                break
            }
        }
    }
}
