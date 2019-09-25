//
//  Provider.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

@objc(Provider)
class Provider: NSObject, NSCoding {
    
    var displayName: String?
    var logoURI: String?
    var providerID: String?
    
    override init() {
        
    }
    
    init(withObject object:[String: String]) {
        super.init()
        
        self.install(withObject: object)
    }
    
    func install(withObject object:[String: String]) {
        self.displayName = object[TrueLayerString.DISPLAY_NAME]
        self.logoURI = object[TrueLayerString.LOGO_URI]
        self.providerID = object[TrueLayerString.PROVIDER_ID]
    }
    
    func copy(_ from:Provider) {
        self.displayName = from.displayName
        self.logoURI = from.logoURI
        self.providerID = from.providerID
    }
    
    init(withDisplayName displayName:String, LogoURI logoURI:String, ProviderID providerID:String) {
        super.init()
        
        self.displayName = displayName
        self.logoURI = logoURI
        self.providerID = providerID
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let displayName = aDecoder.decodeObject(forKey: TrueLayerString.DISPLAY_NAME) as! String
        let logoURI = aDecoder.decodeObject(forKey: TrueLayerString.LOGO_URI) as! String
        let providerID = aDecoder.decodeObject(forKey: TrueLayerString.PROVIDER_ID) as! String
        
        self.init(withDisplayName: displayName, LogoURI: logoURI, ProviderID: providerID)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.displayName, forKey: TrueLayerString.DISPLAY_NAME)
        aCoder.encode(self.logoURI, forKey: TrueLayerString.LOGO_URI)
        aCoder.encode(self.providerID, forKey: TrueLayerString.PROVIDER_ID)
    }
    
    func archive(_ key:String, into:UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into:UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! Provider
        
        self.copy(object)
    }
}
