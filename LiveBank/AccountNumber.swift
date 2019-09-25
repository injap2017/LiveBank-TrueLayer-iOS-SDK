//
//  AccountNumber.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

@objc(AccountNumber)
class AccountNumber: NSObject, NSCoding {
    var iban: String?
    var number: String?
    var sortCode: String?
    var swiftBic: String?
    
    override init() {
        
    }
    
    init(withObject object:[String: String]) {
        super.init()
        
        self.install(withObject: object)
    }
    
    func install(withObject object:[String: String]) {
        self.iban = object[TrueLayerString.IBAN]
        self.number = object[TrueLayerString.NUMBER]
        self.sortCode = object[TrueLayerString.SORT_CODE]
        self.swiftBic = object[TrueLayerString.SWIFT_BIC]
    }
    
    func copy(_ from:AccountNumber) {
        self.iban = from.iban
        self.number = from.number
        self.sortCode = from.sortCode
        self.swiftBic = from.swiftBic
    }
    
    init(withIban iban:String?, Number number:String, SortCode sortCode:String, SwiftBic swiftBic:String?) {
        super.init()
        
        self.iban = iban
        self.number = number
        self.sortCode = sortCode
        self.swiftBic = swiftBic
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let iban = aDecoder.decodeObject(forKey: TrueLayerString.IBAN) as? String
        let number = aDecoder.decodeObject(forKey: TrueLayerString.NUMBER) as! String
        let sortCode = aDecoder.decodeObject(forKey: TrueLayerString.SORT_CODE) as! String
        let swiftBic = aDecoder.decodeObject(forKey: TrueLayerString.SWIFT_BIC) as? String
        
        self.init(withIban: iban, Number: number, SortCode: sortCode, SwiftBic: swiftBic)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.iban, forKey: TrueLayerString.IBAN)
        aCoder.encode(self.number, forKey: TrueLayerString.NUMBER)
        aCoder.encode(self.sortCode, forKey: TrueLayerString.SORT_CODE)
        aCoder.encode(self.swiftBic, forKey: TrueLayerString.SWIFT_BIC)
    }
    
    func archive(_ key:String, into:UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into:UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! AccountNumber
        
        self.copy(object)
    }
}
