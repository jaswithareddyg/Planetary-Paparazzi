//
//  LoadList.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import SwiftUI
import Combine

struct LoadList : View {
    
    enum LoadMsgIcon: String {
        case loading = "cloud.rain"
        case empty = "tornado"
        case error = "cloud.bolt"
    }
    
    var apodType: UserData.Label
    @Binding var contents: [BlockData]
    @State var isError: Bool = false
    @State var errorMsg: String = ""
    
    var message: (LoadMsgIcon, String) {
        
        if UserData.shared.isLoading {
            return (LoadMsgIcon.loading, "loading")
        }else {
            if isError {
                return (LoadMsgIcon.error, errorMsg)
            }else {
                return (LoadMsgIcon.empty, "empty")
            }
        }
    }
    
    var body: some View {
        VStack{
            if contents.isEmpty {
                Placeholder(systemName: message.0.rawValue, showTitle: message.1.capitalized)
                    .padding(.top, 180)
                    .onAppear {
                        self.request()
                    }
            }else {
                ForEach(contents) { apod in
                    Card(block: apod)
                        .padding([.top, .bottom])
                }
                
                if apodType == .random {
                    Button(action: {
                        self.request(.append)
                    }) {
                        Text("More")
                    }
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width - 24)
    }
    
    func request(_ type: Request.LoadType = .refresh) {
        
        isError = false
        
        switch apodType {
        case .today:
            fallthrough
        case .random:
            UserData.shared.loadHandle?.cancel()
            UserData.shared.isLoading = true
            UserData.shared.sendOnlineRequest(delegate: self, type: type)
        }
    }
}

extension LoadList: RequestDelegate {
    func requestError(_ error: Request.RequestError) {
        isError = true
        
        switch error {
        case .Other(let msg):
            errorMsg = msg
            break
        case .UrlError(let error):
            errorMsg = error.localizedDescription
            break
        default:
            break
        }
    }
    
    func requestSuccess(_ apods: [BlockData], _ type: Request.LoadType) {
        isError = false        
        DispatchQueue.main.sync {
            switch type {
            case .refresh:
                contents = apods
            case .append:
                contents.append(contentsOf: apods)
            }
        }
    }
}


struct CardList_Previews : PreviewProvider {
    static var previews: some View {
        ScrollView{
            LoadList(apodType: .today, contents: .constant([]))
        }
    }
}
