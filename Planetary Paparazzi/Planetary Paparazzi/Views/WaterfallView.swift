//
//  WaterfallView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/20/23.
//

import SwiftUI

struct WaterfallView : View {
    @EnvironmentObject var userData: UserData
    
    func reloadSelected() {
        UserData.shared.sendOnlineRequest(delegate: self, type: .refresh)
    }
    
    var selectedContent: Binding<[BlockData]> {
        switch userData.currentLabel {
        case .recent:
            return $userData.localApods
        case .random:
            return $userData.randomApods
        }
    }
    
    var body: some View {
        ScrollView {
            WfHeader(reloadDelegate: reloadSelected, loadState: $userData.isLoading)
                .environmentObject(userData)
                .padding(.bottom, 8)
                .zIndex(100.0)
            
            Picker(selection: $userData.currentLabel, label: Text("Mode")) {
                ForEach(UserData.Label.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 275)
            .zIndex(100)
                
            WfLoadList(apodType: userData.currentLabel, contents: selectedContent)
            .padding([.top], 24)
            .opacity(userData.isLoading ? 0.6 : 1)
            
        }
    }
}

extension WaterfallView: RequestDelegate {
    func requestError(_ error: Request.RequestError) {}
    func requestSuccess(_ apods: [BlockData], _ type: Request.LoadType) {
        if type == .refresh {
            selectedContent.wrappedValue = apods
        }else {
            selectedContent.wrappedValue.append(contentsOf: apods)
        }
    }
}


struct WaterfallView_Previews : PreviewProvider {
    static var previews: some View {
        WaterfallView()
        .environmentObject(UserData.shared)
    }
}
