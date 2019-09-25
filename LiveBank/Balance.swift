//
//  Balance.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

// - Balance ORM Class
@objc(Balance)
class Balance: NSObject, NSCoding {
    var available: Double?
    var current: Double?
    var updateTimestamp: String?
    var currency: String?
    
    override init() {
        
    }
    
    init(withObject object:[String: Any]) {
        super.init()
        
        self.install(withObject: object)
    }
    
    func install(withObject object:[String: Any]) {
        self.currency = object[TrueLayerString.CURRENCY] as? String
        self.available = object[TrueLayerString.AVAILABLE] as? Double
        self.current = object[TrueLayerString.CURRENT] as? Double
        self.updateTimestamp = object[TrueLayerString.UPDATE_TIMESTAMP] as? String
    }
    
    func copy(_ from:Balance) {
        self.current = from.current
        self.available = from.available
        self.currency = from.currency
        self.updateTimestamp = from.updateTimestamp
    }
    
    init(withAvailable available:Double, Current current:Double, UpdateTimestamp updateTimestamp:String, Currency currency:String) {
        super.init()
        
        self.currency = currency
        self.available = available
        self.current = current
        self.updateTimestamp = updateTimestamp
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let currency = aDecoder.decodeObject(forKey: TrueLayerString.CURRENCY) as! String
        let available = aDecoder.decodeObject(forKey: TrueLayerString.AVAILABLE) as! Double
        let current = aDecoder.decodeObject(forKey: TrueLayerString.CURRENT) as! Double
        let updateTimestamp = aDecoder.decodeObject(forKey: TrueLayerString.UPDATE_TIMESTAMP) as! String
        
        self.init(withAvailable: available, Current: current, UpdateTimestamp: updateTimestamp, Currency: currency)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.currency, forKey: TrueLayerString.CURRENCY)
        aCoder.encode(self.current, forKey: TrueLayerString.CURRENT)
        aCoder.encode(self.available, forKey: TrueLayerString.AVAILABLE)
        aCoder.encode(self.updateTimestamp, forKey: TrueLayerString.UPDATE_TIMESTAMP)
    }
    
    func archive(_ key:String, into:UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into:UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Balance
        
        self.copy(object)
    }
}
