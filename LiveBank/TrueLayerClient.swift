//
//  TrueLayerClient.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/14/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit
import Alamofire

@objc(TrueLayerClient)
class TrueLayerClient: NSObject, NSCoding {

    private var clientId: String?
    private var clientSecret: String?
    private var redirectURI: String?
    
    private override init() {
        super.init()
        
        self.reload()
    }
    
    private init(withClientID clientId:String, ClientSecret clientSecret:String, RedirectURI redirectURI:String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    
    func install(withClientID clientId:String, ClientSecret clientSecret:String, RedirectURI redirectURI:String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    
    func copy(_ from:TrueLayerClient) {
        self.clientId = from.clientId
        self.clientSecret = from.clientSecret
        self.redirectURI = from.redirectURI
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let clientId = aDecoder.decodeObject(forKey: TrueLayerString.CLIENT_ID) as! String
        let clientSecret = aDecoder.decodeObject(forKey: TrueLayerString.CLIENT_SECRET) as! String
        let redirectURI = aDecoder.decodeObject(forKey: TrueLayerString.REDIRECT_URI) as! String
        
        self.init(withClientID: clientId, ClientSecret: clientSecret, RedirectURI: redirectURI)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.clientId, forKey: TrueLayerString.CLIENT_ID)
        aCoder.encode(self.clientSecret, forKey: TrueLayerString.CLIENT_SECRET)
        aCoder.encode(self.redirectURI, forKey: TrueLayerString.REDIRECT_URI)
    }
    
    func archive(_ key:String, into: UserDefaults) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        into.set(encodedData, forKey: key)
        into.synchronize()
    }
    
    func unarchive(_ key:String, into: UserDefaults) {
        let decoded = into.object(forKey: key) as! Data
        let object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! TrueLayerClient
        
        self.copy(object)
    }
    
    func reload() {
        if TrueLayerStore.store()!.isKeyPresent(TrueLayerString.TRUELAYER_STORE_KEY) {
            self.unarchive(TrueLayerString.TRUELAYER_STORE_KEY, into: TrueLayerStore.store()!)
        }
        if TrueLayerStore.store()!.isKeyPresent(TrueLayerString.USER_STORE_KEY) {
            self.user.unarchive(TrueLayerString.USER_STORE_KEY, into: TrueLayerStore.store()!)
        }
    }
    
    func clean() {
        self.clientSecret = nil
        self.clientId = nil
        self.redirectURI = nil
    }
    
    // - Additional Members
    private var user = User()
    private static let shared = TrueLayerClient()
    
    // - Public APIs for outter use
    class func reload() {
        TrueLayerClient.shared.reload()
    }
    
    class func currentRedirectURI() -> String? {
        return shared.redirectURI
    }
    
    class func currentClientId() -> String? {
        return shared.clientId
    }
    
    class func currentClientSecret() -> String? {
        return shared.clientSecret
    }
    
    class func currentAccessToken() -> String? {
        return shared.user.accessToken
    }
    
    class func logout() {
        
        // remove truelayer
        shared.clean()
        TrueLayerStore.store()!.removeObject(forKey: TrueLayerString.TRUELAYER_STORE_KEY)
        
        // remove user
        shared.user.clean()
        TrueLayerStore.store()!.removeObject(forKey: TrueLayerString.USER_STORE_KEY)
    }
    
    class func install(withId Id:(String), Secret secret:(String), RedirectURI redirectURI:(String)) {
        // remove truelayer
        shared.clean()
        TrueLayerStore.store()!.removeObject(forKey: TrueLayerString.TRUELAYER_STORE_KEY)
        
        // save id, secret, redirecturi
        shared.install(withClientID: Id, ClientSecret: secret, RedirectURI: redirectURI)
        shared.archive(TrueLayerString.TRUELAYER_STORE_KEY, into: TrueLayerStore.store()!)
        
        // remove user
        shared.user.clean()
        TrueLayerStore.store()!.removeObject(forKey: TrueLayerString.USER_STORE_KEY)
    }
    
    class func exchangeCode(code: String, failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil) {
        shared.exchangeCode(code: code, failure: fail, success: succeed)
    }
    
    class func refreshToken(failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil) {
        shared.refreshToken(shared.user.refreshToken!, failure: fail, success: succeed)
    }
    
    class func retrieveMetadata(failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil) {
        shared.retrieveMetadata(accessToken: shared.user.accessToken!, failure: fail, success: succeed)
    }
    
    class func getBalance(ofAccount account: String, failure fail: ((Error) -> ())? = nil, success succeed: ((Balance) -> ())? = nil) {
        shared.retrieveBalance(ofAccount: account, accessToken: shared.user.accessToken! , failure: fail, success: succeed)
    }
    
    class func getAccounts(failure fail: ((Error) -> ())? = nil, success succeed: (([Account]) -> ())? = nil) {
        shared.retrieveAccounts(accessToken: shared.user.accessToken!, failure: fail, success: succeed)
    }
    
    // - Endpoints
    private func exchangeCode(code: String, failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil){
        let params: Parameters = [
            "grant_type": "authorization_code",
            "client_id": self.clientId!,
            "client_secret": self.clientSecret!,
            "redirect_uri": self.redirectURI!,
            "code": code
        ]
        Alamofire.request(TrueLayerString.AUTH_URL + "connect/token", method: .post, parameters: params).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                self.user.install(withObject: json)
                
                self.user.archive(TrueLayerString.USER_STORE_KEY, into: TrueLayerStore.store()!)
                
                if let s = succeed {
                    s()
                }
            }
        }
    }
    
    private func refreshToken(_ refreshToken: String, failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil){
        let params: Parameters = [
            "grant_type": "refresh_token",
            "client_id": self.clientId!,
            "client_secret": self.clientSecret!,
            "refresh_token": refreshToken,
            ]
        Alamofire.request(TrueLayerString.AUTH_URL + "connect/token", method: .post, parameters: params).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    self.user.install(withObject: json)
                    
                    TrueLayerStore.store()!.removeObject(forKey: TrueLayerString.USER_STORE_KEY)
                    self.user.archive(TrueLayerString.USER_STORE_KEY, into: TrueLayerStore.store()!)
                    
                    if let s = succeed {
                        s()
                    }
                }
                break
            case .failure(let error):
                if let f = fail {
                    f(error)
                }
                break
            }
        }
    }

    private func retrieveAccounts(accessToken: String, failure fail: ((Error) -> ())? = nil, success succeed: (([Account]) -> ())? = nil){
        let authHeader = [
            "Authorization": "Bearer \(accessToken)"
        ]
        Alamofire.request(TrueLayerString.DATA_URL + "/accounts", method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                if let results = json["results"] as? [Any] {
                    let accounts = results.map({ (result) -> Account in
                        let object = result as! [String: Any]
                        return Account(withObject:object)
                    })
                    
                    if let s = succeed {
                        s(accounts)
                    }
                }
            }
        }
    }
    
    private func retrieveBalance(ofAccount account:String, accessToken: String, failure fail: ((Error) -> ())? = nil, success succeed: ((Balance) -> ())? = nil){
        let authHeader = [
            "Authorization": "Bearer \(accessToken)"
        ]
        Alamofire.request(TrueLayerString.DATA_URL + "/accounts/\(account)/balance", method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).validate().responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                
                guard error is AFError else {
                    if let f = fail {
                        f(error)
                    }
                    
                    return
                }
                
                let aferror = error as! AFError
                
                guard aferror.isResponseValidationError else {
                    if let f = fail {
                        f(error)
                    }
                    
                    return
                }
                
                // require refresh token
                print(" require refresh token")
                self.refreshToken(self.user.refreshToken!, failure: { error in
                    if let f = fail {
                        f(error)
                    }
                }, success: {
                    DispatchQueue.main.async {
                        self.retrieveBalance(ofAccount: account, accessToken: accessToken, failure: fail, success:  succeed)
                    }
                })
                
                break
            case .success(let value):
                if let json = value as? [String: Any] {
                    if let results = json["results"] as? [Any] {
                        if let object = results[0] as? [String: Any] {
                            let balance = Balance(withObject:object)
                            
                            if let s = succeed {
                                s(balance)
                            }
                        }
                    }
                }
                
                break
            }
        }
    }

    private func retrieveMetadata(accessToken: String, failure fail: ((Error) -> ())? = nil, success succeed: (() -> ())? = nil){
        let authHeader = [
            "Authorization": "Bearer \(accessToken)"
        ]
        Alamofire.request(TrueLayerString.DATA_URL + "/me", method: .get, parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { response in
            
            if let json = response.result.value as? [String: Any] {
                if let results = json["results"] as? [Any] {
                    if let object = results[0] as? [String: Any] {
                        
                        print(object)
                        
                        if let s = succeed {
                            s()
                        }
                    }
                }
            }
        }
    }
}
