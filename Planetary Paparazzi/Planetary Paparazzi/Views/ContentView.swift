//
//  ContentView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/18/23.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        TabView {
            WaterfallView()
                .environmentObject(UserData.shared)
                .tabItem {
                    VStack{
                        Image(systemName: "skew")
                        Text("Feed")
                    }
                }
                .tag(1)
            
            SettingView()
                .environmentObject(UserSetting.shared)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(2)
        }
    }
}


struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()     
            ContentView()
                .colorScheme(.dark)
        }
        
    }
}
