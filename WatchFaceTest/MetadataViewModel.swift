//
//  MetadataViewModel.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import UIKit
import NorthLayout
import Ikemen

final class MetadataViewModel: NSObject, NSOutlineViewDelegate, NSOutlineViewDataSource {
    var reloadAndExpand: (() -> Void)?
    private var metadataPropertyList: [String: Any]? {
        didSet {
            reloadAndExpand?()
        }
    }

    func setWatchface(_ watchface: Watchface) {
        metadataPropertyList = [
            "metadata.json": (try? PropertyListEncoder().encode(watchface.metadata))
                .flatMap {try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil)},
            "face.json": (try? PropertyListEncoder().encode(watchface.face))
                .flatMap {try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil)},
            "complicationData/": (try? PropertyListEncoder().encode(watchface.complicationData))
                .flatMap {try? PropertyListSerialization.propertyList(from: $0, options: [], format: nil)}].compactMapValues {$0}
    }

    func outlineView(_ outlineView: UIOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        switch item {
        case nil: return 1
        case let array as [Any]: return array.count
        case let dictionary as [String: Any]: return dictionary.count
        case let (_, array) as (String, [Any]): return array.count
        case let (_, dictionary) as (String, [String: Any]): return dictionary.count
        default: return 0
        }
    }

    func outlineView(_ outlineView: UIOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let plist = metadataPropertyList else { return "(null)" }
        switch item {
        case nil: return plist
        case let array as [Any],
             let (_, array) as (String, [Any]):
            return array[index]
        case let dictionary as [String: Any],
             let (_, dictionary) as (String, [String: Any]):
            let key = Array(dictionary.keys.sorted())[index]
            let value = dictionary[key]
            return (key, value)
        default: return "(unknown)"
        }
    }

    func outlineView(_ outlineView: UIOutlineView, isItemExpandable item: Any) -> Bool {
        switch item {
        case is [Any]: return true
        case is [String: Any]: return true
        case is (String, [Any]): return true
        case is (String, [String: Any]): return true
        default: return false
        }
    }

    func outlineView(_ outlineView: UIOutlineView, objectValueFor tableColumn: UITableColumn?, byItem item: Any?) -> Any? {
        switch item {
        case let array as [Any]: return "Array (\(array.count) Items)"
        case let (key, array) as (String, [Any]):
            return [NSAttributedString(string: "\(key) = ", attributes: [.foregroundColor: NSColor.secondaryLabelColor]), NSAttributedString(string: "Array (\(array.count) Items)")]
                .reduce(into: NSMutableAttributedString()) {$0.append($1)}
        case let dictionary as [String: Any]: return "Dictionary (\(dictionary.count) Pairs)"
        case let (key, dictionary) as (String, [String: Any]):
            return [NSAttributedString(string: "\(key) = ", attributes: [.foregroundColor: NSColor.secondaryLabelColor]), NSAttributedString(string: "Dictionary (\(dictionary.count) Pairs)")]
                .reduce(into: NSMutableAttributedString()) {$0.append($1)}
        case let (key, value) as (String, Any?):
            return [NSAttributedString(string: "\(key) = ", attributes: [.foregroundColor: NSColor.secondaryLabelColor]), NSAttributedString(string: "\(value ?? "(null)")")]
                .reduce(into: NSMutableAttributedString()) {$0.append($1)}
        default: return item
        }
    }

    func outlineView(_ outlineView: UIOutlineView, shouldEdit tableColumn: NSTableColumn?, item: Any) -> Bool { true }

    func outlineView(_ outlineView: UIOutlineView, willDisplayCell cell: Any, for tableColumn: UITableColumn?, item: Any) {
        (cell as? UITextFieldCell)?.isEditable = false
        (cell as? UITextFieldCell)?.isSelectable = true
        (cell as? UITextFieldCell)?.truncatesLastVisibleLine = true
    }
}
