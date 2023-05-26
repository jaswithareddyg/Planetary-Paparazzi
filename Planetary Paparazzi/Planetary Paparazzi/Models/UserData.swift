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
    
    enum WfLabel: String, CaseIterable {
        case recent = "Recent"
        case random = "Random"
        case saved = "Saved"
    }
    
    @Published var localApods: [BlockData] = []
    
    @Published var randomApods: [BlockData] = []
    
    @Published var savedApods: [BlockData] = []
    
    var selectedList: [BlockData] {
        switch currentLabel {
        case .recent:
            return localApods
        case .random:
            return randomApods
        case .saved:
            return savedApods
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
    
    @Published var currentLabel: WfLabel = .recent
    
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
