//
//  UserData.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    private init() {}
    static let shared = UserData()
    enum Label: String, CaseIterable {
        case today = "Today"
        case random = "Random"
    }
    
    @Published var curApods: [BlockData] = []
    @Published var randomApods: [BlockData] = []
    
    var selectedList: [BlockData] {
        switch currentLabel {
        case .today:
            return curApods
        case .random:
            return randomApods
        }
    }
    
    func sendOnlineRequest(delegate: RequestDelegate, type: Request.LoadType) {
        loadHandle?.cancel()
        self.isLoading = true
        var request = Request(type: type)
        
        request.bindingDelegate(delegate)
        request.bindingDelegate(self)
        request.hd = UserSetting.shared.loadHdImage

        if currentLabel == .random {
            request.count = 10
        }
        
        loadHandle = request.sendRequest()
    }
    
    @Published var currentLabel: Label = .today
    @Published var isLoading: Bool = false
    
    var loadHandle: AnyCancellable?
}

extension UserData: RequestDelegate {
    func requestError(_ error: Request.RequestError) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    func requestSuccess(_ apods: [BlockData], _ type: Request.LoadType) {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    
}
