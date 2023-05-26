//
//  SplashView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/24/23.
//

import SwiftUI

struct SplashView: View {
    
    @State private var offset = CGSize.zero
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            ContentView()
        } else {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    // text with custom font and effect
                    Text("Planetary Paparazzi")
                        .font(.custom("ZilapOrionPersonalUseFuturistic-DzA3.ttf", size: 60))
                        .foregroundColor(Color(hue: 0.001, saturation: 0.0, brightness: 0.98))
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            .offset(offset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    self.offset = CGSize(width: 0, height: 10)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors:[Color(hex: "2C5364"), Color(hex: "203A43"), Color(hex: "0F2027")]), startPoint: .top, endPoint: .bottom)

                            .ignoresSafeArea()
            )
            
            // shows the splash screen for 10 seconds and also prints to console
            .onAppear{
                print("Splash Screen is loading for 10 seconds...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.isActive = true
                }
            }
        }
    }
}

/// extension to convert hex codes to RGB values that Swift understands.
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
