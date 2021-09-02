//
//  AppSettings.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 26.08.2021.
//

import Foundation

protocol AppSettingsProtocol {
    var isLoggedIn: Bool { get set }
}

final class AppSettings: AppSettingsProtocol {
    
    fileprivate let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
}

extension AppSettings {
    
    var isLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: #function)
        }
        set {
            userDefaults.set(newValue, forKey: #function)
        }
    }
    
}
