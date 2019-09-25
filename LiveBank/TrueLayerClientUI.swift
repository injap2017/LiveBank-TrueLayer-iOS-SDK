//
//  TrueLayerClientUI.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/19/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation
import UIKit

class TruelayerClientUI {
    static let shared = TruelayerClientUI()
    
    class func TrueLayerViewController() -> TrueLayerViewController? {
        let storyboard = UIStoryboard(name: "TrueLayerStoryboard", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "truelayer") as? TrueLayerViewController
    }
}
