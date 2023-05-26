//
//  Helper.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import Foundation

extension UserDefaults {
    enum UserKey: String {
        case ApiKey
        case AutoHdImage
    }
    
    static func saveCustomValue(for key: UserKey, value: Any) {
        self.standard.set(value, forKey: key.rawValue)
    }
    
    static func getCustomValue(for key: UserKey) -> Any? {
        self.standard.object(forKey: key.rawValue)
    }
}

