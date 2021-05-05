//
//  WindowController.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

#if !os(iOS)
import Cocoa
#endif
import Ikemen

final class WindowController: NSWindowController, NSToolbarDelegate, NSSharingServicePickerToolbarItemDelegate {
    init(document: Document) {
        let window = NSWindow(contentViewController: ViewController(document: document))
        super.init(window: window)
        window.toolbar = NSToolbar(identifier: "WindowController") ※ {
            $0.delegate = self
            $0.allowsUserCustomization = true
        }
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.addImage, .removeImage, .share, .mediaLibrary, .space, .flexibleSpace]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.flexibleSpace, .addImage, .removeImage, .mediaLibrary, .space, .share]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        switch itemIdentifier {
        case .share: return NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier) ※ {
            $0.delegate = self
        }
        case .addImage: return NSToolbarItem(itemIdentifier: itemIdentifier) ※ {
            $0.label = "Add Photo"
            $0.image = NSImage(named: NSImage.addTemplateName)
            $0.isBordered = true
            $0.action = #selector(ViewController.addImage)
        }
        case .removeImage: return NSToolbarItem(itemIdentifier: itemIdentifier) ※ {
            $0.label = "Remove Photo"
            $0.image = NSImage(named: NSImage.removeTemplateName)
            $0.isBordered = true
            $0.target = nil
            $0.action = #selector(ViewController.removeImage)
        }
        case .mediaLibrary: return NSToolbarItem(itemIdentifier: itemIdentifier) ※ {
            $0.label = "Library"
            $0.image = NSImage(named: "NSMediaBrowserMediaTypePhotos")
            $0.isBordered = true
            $0.target = nil
            $0.action = #selector(WindowController.showMediaLibrary)
        }
        default: return NSToolbarItem(itemIdentifier: itemIdentifier)
        }
    }

    func items(for pickerToolbarItem: NSSharingServicePickerToolbarItem) -> [Any] {
        [(contentViewController as! ViewController).document]
    }
    
    @IBAction func showMediaLibrary(_ sender: Any?) {
        let mediaBrowser = NSMediaLibraryBrowserController.shared
        mediaBrowser.mediaLibraries = [.image]
        if !mediaBrowser.isVisible {
            mediaBrowser.togglePanel(nil)
        }
    }
}

private extension NSToolbarItem.Identifier {
    static let share: NSToolbarItem.Identifier = .init("share")
    static let addImage: NSToolbarItem.Identifier = .init("addImage")
    static let removeImage: NSToolbarItem.Identifier = .init("removeImage")
    static let mediaLibrary: NSToolbarItem.Identifier = .init("mediaLibrary")
}
