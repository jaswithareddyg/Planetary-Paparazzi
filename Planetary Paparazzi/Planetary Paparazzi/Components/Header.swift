//
//  Header.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import SwiftUI

struct Header: View {
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    var reloadDelegate: () -> ()
    @Binding var loadState: Bool
    @State var btnAngle = 180.0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("NASA's Astronomy Picture of the Day")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    self.reloadDelegate()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: self.loadState ? btnAngle : 0))
                        .disabled(self.loadState == true)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                if self.loadState {
                                    withAnimation(.easeInOut){
                                        self.btnAngle += 12.0
                                        self.btnAngle.formTruncatingRemainder(dividingBy: 360.0)
                                    }
                                } else {
                                    withAnimation(.easeInOut){
                                        self.btnAngle = 180.0
                                    }
                                }
                            }
                        }
                }
            }
            Text(currentDateStr.uppercased())
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
            Spacer()
            Divider()
        }
        .padding()
        
    }
}


struct Header_Previews : PreviewProvider {
    static var previews: some View {
        Header(reloadDelegate: {}, loadState: .constant(false) )
            .previewLayout(.sizeThatFits)
    }
}
