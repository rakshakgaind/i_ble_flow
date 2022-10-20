//
//  SessionManager.swift
//  BleDemo
//
//  Created by Admin on 13/10/22.
//

import Foundation

class SessionManager {
    
    private static var instance: SessionManager!
    static func getInstance() -> SessionManager {
        if instance == nil {
            instance = SessionManager()
        }
        return instance
    }
    
    private init() {}
    
    var userDefaul = UserDefaults.standard
    
    func setValue(key: String, value: Any) {
        userDefaul.setValue(value, forKey: key)
    }
    
    func getInt(key: String) -> Int {
        userDefaul.integer(forKey: key)
    }
    
    func getString(key: String) -> String? {
        userDefaul.string(forKey: key)
    }
}

class SessionConstant {
    static let DEVICE_ID = "device_id"
}
