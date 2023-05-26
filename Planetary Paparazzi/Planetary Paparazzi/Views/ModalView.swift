//
//  ModalView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/20/23.
//

import SwiftUI

struct ModalView : View {
    
    @Binding var block: BlockData
    
    var apod: Result {
        block.content
    }
    
    @Binding var loadedImage: UIImage?
    
    var body: some View {
        VStack{
            VStack {
                    if apod.mediaType == .Image {
                        AsyncImage(url: apod.hdurl!, image: $loadedImage)
                            .scaledToFit()
                            
                    }else {
                        WebView(request: .init(url: apod.url!))
                    }
                }
                .clipped()
                .padding(0.0)
            
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(apod.title)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2)
                    
                    HStack {
                        Text(apod.getFormatterDate())
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            self.block.favourite.toggle()
                        }) {
                            Image(systemName: self.block.favourite ? "star.fill" : "star")
                                .imageScale(.small)
                                .foregroundColor(self.block.favourite ? .yellow : .gray)
                        }
                        
                        
                    }
                    
                }
                
                
                Text(apod.explanation)
                    .font(.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                if apod.copyright != nil {
                    Text("© \(apod.copyright!)")
                }
            }
        }
    }
}

struct Modal_Previews : PreviewProvider {
    static var previews: some View {
        ModalView(block: .constant(.init(content: singleApod)) , loadedImage: .constant(nil))
    }
}
