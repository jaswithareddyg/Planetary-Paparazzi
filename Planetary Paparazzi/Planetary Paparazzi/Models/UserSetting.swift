//
//  UserSetting.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import Foundation
import Combine

final class UserSetting: ObservableObject {
    let objectWillChange: ObjectWillChangePublisher = ObjectWillChangePublisher()
    private init() {}
    static let shared = UserSetting()
    
    var apiKey: String {
        set {
            objectWillChange.send()
            UserDefaults.saveCustomValue(for: .ApiKey, value: newValue)
        }
        get {
            if let value = UserDefaults.getCustomValue(for: .ApiKey) as? String {
                return value
            }else {
                UserDefaults.saveCustomValue(for: .ApiKey, value: "DEMO_KEY")
                return "DEMO_KEY"
            }
        }
    }
    
    var loadHdImage: Bool {
        set {
            objectWillChange.send()
            UserDefaults.saveCustomValue(for: .AutoHdImage, value: newValue)
        }
        get {
            if let value = UserDefaults.getCustomValue(for: .AutoHdImage) as? Bool {
                return value
            } else {
                UserDefaults.saveCustomValue(for: .AutoHdImage, value: true)
                return true
            }
        }
    }
}
