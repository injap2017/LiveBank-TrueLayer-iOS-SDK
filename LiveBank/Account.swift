//
//  Account.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

// - Account ORM Class
@objc(Account)
class Account: NSObject, NSCoding {
    var accountID: String?
    var accountType: String?
    var currency: String?
    var displayName: String?
    var updateTimestamp: String?
    
    var accountNumber: AccountNumber?
    var provider: Provider?
    
    override init() {
        
    }
    
    init(withObject object:[String: Any]) {
        super.init()
        
        self.install(withObject: object)
    }
    
    func install(withObject object:[String: Any]) {
        self.accountID = object[TrueLayerString.ACCOUNT_ID] as? String
        self.accountType = object[TrueLayerString.ACCOUNT_TYPE] as? String
        self.currency = object[TrueLayerString.CURRENCY] as? String
        self.displayName = object[TrueLayerString.DISPLAY_NAME] as? String
        self.updateTimestamp = object[TrueLayerString.UPDATE_TIMESTAMP] as? String
        self.accountNumber = AccountNumber(withObject:object[TrueLayerString.ACCOUNT_NUMBER] as! [String: String])
        self.provider = Provider(withObject:object[TrueLayerString.PROVIDER] as! [String: String])
    }
    
    func copy(_ from:Account) {
        self.accountID = from.accountID
        self.accountType = from.accountType
        self.currency = from.currency
        self.displayName = from.displayName
        self.updateTimestamp = from.updateTimestamp
        self.accountNumber = from.accountNumber
        self.provider = from.provider
    }
    
    init(withAccountID accountID:String, AccountType accountType:String, Currency currency:String, DisplayName displayName:String, UpdateTimestamp updateTimestamp:String, AccountNumber accountNumber:AccountNumber, Provider provider:Provider) {
        super.init()
        
        self.accountID = accountID
        self.accountType = accountType
        self.currency = currency
        self.displayName = displayName
        self.updateTimestamp = updateTimestamp
        self.accountNumber = accountNumber
        self.provider = provider
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let accountID = aDecoder.decodeObject(forKey: TrueLayerString.ACCOUNT_ID) as! String
        let accountType = aDecoder.decodeObject(forKey: TrueLayerString.ACCOUNT_TYPE) as! String
        let currency = aDecoder.decodeObject(forKey: TrueLayerString.CURRENCY) as! String
        let displayName = aDecoder.decodeObject(forKey: TrueLayerString.DISPLAY_NAME) as! String
        let updateTimestamp = aDecoder.decodeObject(forKey: TrueLayerString.UPDATE_TIMESTAMP) as! String
        let accountNumber = aDecoder.decodeObject(forKey: TrueLayerString.ACCOUNT_NUMBER) as! AccountNumber
        let provider = aDecoder.decodeObject(forKey: TrueLayerString.PROVIDER) as! Provider
        
        self.init(withAccountID: accountID, AccountType: accountType, Currency: currency, DisplayName: displayName, UpdateTimestamp: updateTimestamp, AccountNumber: accountNumber, Provider: provider)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.accountID, forKey: TrueLayerString.ACCOUNT_ID)
        aCoder.encode(self.accountType, forKey: TrueLayerString.ACCOUNT_TYPE)
        aCoder.encode(self.currency, forKey: TrueLayerString.CURRENCY)
        aCoder.encode(self.displayName, forKey: TrueLayerString.DISPLAY_NAME)
        aCoder.encode(self.updateTimestamp, forKey: TrueLayerString.UPDATE_TIMESTAMP)
        aCoder.encode(self.accountNumber, forKey: TrueLayerString.ACCOUNT_NUMBER)
        aCoder.encode(self.provider, forKey: TrueLayerString.PROVIDER)
    }
    
    func archive(_ key:String, into:UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into:UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Account
        
        self.copy(object)
    }
}
