//
//  TrueLayerStore.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/19/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

class TrueLayerStore {
    private let defaults = UserDefaults.init(suiteName: "group.truelayer")
    private static let shared = TrueLayerStore()
    
    class func store() -> UserDefaults? {
        return shared.defaults
    }
}
