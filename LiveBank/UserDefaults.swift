//
//  UserDefaults.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/18/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

extension UserDefaults {
    func isKeyPresent(_ key: String) -> Bool {
        return self.object(forKey: key) != nil
    }
}
