//
//  Placeholder.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import Foundation
import SwiftUI

struct Placeholder : View {
    
    var systemName: String
    var showTitle: String?
    
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .colorMultiply(.secondary)
                .imageScale(.large)
                .padding([.top, .bottom], 4)
            
            if showTitle != nil {
                Text(showTitle!)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing])
            }
        }
    }
}


struct Placeholder_Previews : PreviewProvider {
    static var previews: some View {
        Placeholder(systemName: "cloud.bolt" , showTitle: "You have exceeded your rate limit. Try again later or contact us at https://api.nasa.gov:443/contact/ for assistance")
    }
}
