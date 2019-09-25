//
//  User.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

// User ORM class
@objc(User)
internal class User: NSObject, NSCoding {
    var accessToken: String?
    var refreshToken: String?
    var expiresIn: UInt?
    var tokenType: String?
    
    override init() {
        
    }
    
    init(withObject object:[String: Any]) {
        super.init()
        
        self.install(withObject: object)
    }
    
    func install(withObject object:[String: Any]) {
        self.tokenType = object[TrueLayerString.TOKEN_TYPE] as? String
        self.accessToken = object[TrueLayerString.ACCESS_TOKEN] as? String
        self.refreshToken = object[TrueLayerString.REFRESH_TOKEN] as? String
        self.expiresIn = object[TrueLayerString.EXPIRES_IN] as? UInt
    }
    
    func copy(_ from:User) {
        self.tokenType = from.tokenType
        self.accessToken = from.accessToken
        self.refreshToken = from.refreshToken
        self.expiresIn = from.expiresIn
    }
    
    func clean() {
        self.accessToken = nil
        self.refreshToken = nil
        self.tokenType = nil
        self.expiresIn = nil
    }
    
    init(withTokenType tokenType:String, AccessToken accessToken:String, RefreshToken refreshToken:String, ExpiresIn expiresIn:UInt) {
        super.init()
        
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let tokenType = aDecoder.decodeObject(forKey: TrueLayerString.TOKEN_TYPE) as! String
        let refreshToken = aDecoder.decodeObject(forKey: TrueLayerString.REFRESH_TOKEN) as! String
        let accessToken = aDecoder.decodeObject(forKey: TrueLayerString.ACCESS_TOKEN) as! String
        let expiresIn = aDecoder.decodeObject(forKey: TrueLayerString.EXPIRES_IN) as! UInt
        
        self.init(withTokenType: tokenType, AccessToken: accessToken, RefreshToken: refreshToken, ExpiresIn: expiresIn)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tokenType, forKey: TrueLayerString.TOKEN_TYPE)
        aCoder.encode(self.accessToken, forKey: TrueLayerString.ACCESS_TOKEN)
        aCoder.encode(self.refreshToken, forKey: TrueLayerString.REFRESH_TOKEN)
        aCoder.encode(self.expiresIn, forKey: TrueLayerString.EXPIRES_IN)
    }
    
    func archive(_ key:String, into:UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into:UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
        
        self.copy(object)
    }
}
