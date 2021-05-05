//
//  WatchFace.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import Foundation

public struct Watchface {
    public var metadata: Metadata
    public var face: Face
    public var snapshot: Data
    public var no_borders_snapshot: Data
//    var device_border_snapshot: Data?
    public var resources: Resources?
    public typealias ComplicationData = Metadata.ComplicationPositionDictionary<[String: Data]> // position -> (filename -> content)
    public var complicationData: ComplicationData? = nil

    public init(metadata: Metadata, face: Face, snapshot: Data, no_borders_snapshot: Data, resources: Resources? = nil, complicationData: ComplicationData? = nil) {
        self.metadata = metadata
        self.face = face
        self.snapshot = snapshot
        self.no_borders_snapshot = no_borders_snapshot
        self.resources = resources
        self.complicationData = complicationData
    }
}
