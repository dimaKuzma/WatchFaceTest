//
//  Metadata.swift
//  WatchFaceTest
//
//  Created by Дмитрий on 4/27/21.
//  Copyright © 2021 DK. All rights reserved.
//

import Foundation

extension Watchface {
    public struct Metadata: Codable {
        public var version: Int = 2
        // 38mm, 42mm?
        public var device_size = 2
        public var complication_sample_templates: ComplicationPositionDictionary<ComplicationTemplate>
        public var complications_names: ComplicationPositionDictionary<String>
        public var complications_item_ids: ComplicationPositionDictionary<Int>
        // com.apple.weather.watchapp, com.apple.HeartRate, com.apple.NanoCalendar
        public var complications_bundle_ids: ComplicationPositionDictionary<String>?
        
        public struct ComplicationPositionDictionary<Value: Codable>: Codable {
            public var top: Value?
            public var bottom: Value?
            public var top_left: Value?
            public var top_right: Value?
            public var bottom_left: Value?
            public var bottom_center: Value?
            public var bottom_right: Value?
            public var slot1: Value?
            public var slot2: Value?
            public var slot3: Value?
            public var bezel: Value?
            
            public enum CodingKeys: String, CodingKey, CaseIterable {
                case top, bottom
                case top_left = "top-left"
                case top_right = "top-right"
                case bottom_left = "bottom-left"
                case bottom_center = "bottom-center"
                case bottom_right = "bottom-right"
                case slot1, slot2, slot3
                case bezel
            }
            
            public subscript(_ key: CodingKeys) -> Value? {
                get {
                    switch key {
                    case .top: return top
                    case .bottom: return bottom
                    case .top_left: return top_left
                    case .top_right: return top_right
                    case .bottom_left: return bottom_left
                    case .bottom_center: return bottom_center
                    case .bottom_right: return bottom_right
                    case .slot1: return slot1
                    case .slot2: return slot2
                    case .slot3: return slot3
                    case .bezel: return bezel
                    }
                }
                set {
                    switch key {
                    case .top: top = newValue
                    case .bottom: bottom = newValue
                    case .top_left: top_left = newValue
                    case .top_right: top_right = newValue
                    case .bottom_left: bottom_left = newValue
                    case .bottom_center: bottom_center = newValue
                    case .bottom_right: bottom_right = newValue
                    case .slot1: slot1 = newValue
                    case .slot2: slot2 = newValue
                    case .slot3: slot3 = newValue
                    case .bezel: bezel = newValue
                    }
                }
            }
            
            public init(top: Value? = nil, bottom: Value? = nil, top_left: Value? = nil, top_right: Value? = nil, bottom_left: Value? = nil, bottom_center: Value? = nil, bottom_right: Value? = nil, slot1: Value? = nil, slot2: Value? = nil, slot3: Value? = nil, bezel: Value? = nil) {
                self.top = top
                self.bottom = bottom
                self.top_left = top_left
                self.top_right = top_right
                self.bottom_left = bottom_left
                self.bottom_center = bottom_center
                self.bottom_right = bottom_right
                self.slot1 = slot1
                self.slot2 = slot2
                self.slot3 = slot3
                self.bezel = bezel
            }
        }
        
        public struct Color: Codable {
            public var red: Double
            public var green: Double
            public var blue: Double
            public var alpha: Double
            
            public init(red: Double, green: Double, blue: Double, alpha: Double) {
                self.red = red
                self.green = green
                self.blue = blue
                self.alpha = alpha
            }
        }
        
        public init(version: Int = 2, complication_sample_templates: ComplicationPositionDictionary<ComplicationTemplate>, complications_names: ComplicationPositionDictionary<String>, complications_item_ids: ComplicationPositionDictionary<Int>, complications_bundle_ids: ComplicationPositionDictionary<String>? = nil) {
            self.version = version
            self.complication_sample_templates = complication_sample_templates
            self.complications_names = complications_names
            self.complications_item_ids = complications_item_ids
            self.complications_bundle_ids = complications_bundle_ids
        }
    }
}
