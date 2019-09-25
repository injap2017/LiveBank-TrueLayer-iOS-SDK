//
//  LiveBankStore.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/19/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

class LiveBankStore {
    private let defaults = UserDefaults.init(suiteName: "group.livebank")
    private static let shared = LiveBankStore()
    
    class func store() -> UserDefaults? {
        return shared.defaults
    }
}
