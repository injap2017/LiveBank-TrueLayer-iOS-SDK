//
//  TrueLayerString.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

class TrueLayerString {
    static let AUTH_URL = "https://auth.truelayer.com/"
    static let DATA_URL = "https://api.truelayer.com/data/v1"
    
    static let SCOPES = "offline_access%20info%20accounts%20transactions%20balance"
    
    static let TRUELAYER_STORE_KEY = "truelayer_store_key"
    static let USER_STORE_KEY = "user_store_key"
    
    static let CREDENTIALS_ID = "credentials_id"
    static let REFRESH_TOKEN = "refresh_token"
    static let ACCESS_TOKEN = "access_token"
    static let EXPIRES_IN = "expires_in"
    static let TOKEN_TYPE = "token_type"
    
    static let DISPLAY_NAME = "display_name"
    static let LOGO_URI = "logo_uri"
    
    static let CLIENT_ID = "client_id"
    static let CLIENT_SECRET = "client_secret"
    static let REDIRECT_URI = "redirect_uri"
    static let PROVIDER = "provider"
    static let PROVIDER_ID = "provider_id"
    
    static let IBAN = "iban"
    static let NUMBER = "number"
    static let SORT_CODE = "sort_code"
    static let SWIFT_BIC = "swift_bic"
    
    static let ACCOUNT_ID = "account_id"
    static let ACCOUNT_TYPE = "account_type"
    static let ACCOUNT_NUMBER = "account_number"
    
    static let CURRENCY = "currency"
    static let AVAILABLE = "available"
    static let CURRENT = "current"
    static let UPDATE_TIMESTAMP = "update_timestamp"
}
