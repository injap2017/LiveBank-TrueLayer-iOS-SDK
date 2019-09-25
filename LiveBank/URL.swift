//
//  URL.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/12/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import Foundation

extension URL {
    public var queryItems: [String: String] {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            }) ?? [:]
    }
}
