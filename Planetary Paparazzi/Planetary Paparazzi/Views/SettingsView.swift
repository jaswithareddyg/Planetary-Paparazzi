//
//  SettingsView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/20/23.
//

import SwiftUI

struct SettingView : View {
    @EnvironmentObject var setting: UserSetting
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: TextEditor(original: $setting.apiKey)) {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("API Key")
                                .padding(.trailing, 24)
                            Spacer()
                            
                            Text(setting.apiKey)
                                .foregroundColor(.secondary)
                                .truncationMode(.tail)
                        }
                    }
    
                    Toggle(isOn: $setting.loadHdImage) {
                        HStack {
                            Image(systemName: "map")
                            Text("HD Image")
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
}


struct SettingView_Previews : PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(UserSetting.shared)
    }
}
