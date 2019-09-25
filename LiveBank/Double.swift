//
//  Double.swift
//  LiveBank
//
//  Created by Edgar Sia on 11/15/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func attributedCurrency(from double: Double) -> NSAttributedString? {
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 64, weight: UIFont.Weight.medium)]
        let attributes2 = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)]
        
        let attributedString = NSMutableAttributedString()
        
        // add minus sign
        if double < 0.0 {
            let sign = NSMutableAttributedString(string: "-", attributes: attributes)
            attributedString.append(sign)
        }
        
        // add £
        let pound = NSMutableAttributedString.init(string: "£", attributes: attributes)
        attributedString.append(pound)
        
        // add integer.fractoin
        let doubleString = String(format:"%.2f", fabs(double))
        let doubleComponent = doubleString.components(separatedBy: ".")
        
        let integerString = NSMutableAttributedString.init(string: doubleComponent[0], attributes: attributes)
        attributedString.append(integerString)
        
        let dotString = NSMutableAttributedString.init(string: ".", attributes: attributes2)
        attributedString.append(dotString)
        
        let fractionString = NSMutableAttributedString.init(string: doubleComponent[1], attributes: attributes2)
        attributedString.append(fractionString)
        
        return attributedString
    }
}
