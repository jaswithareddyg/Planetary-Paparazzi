//
//  TextEditor.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/21/23.
//

import SwiftUI

struct TextEditor: View {
    @Binding var original: String
    @State var copy: String = ""
    
    var body: some View {
        List {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    TextField("Edit Text", text: $copy)
                }
            }
            
            Section {
                Button(action: {
                    self.original = self.copy
                }) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Update")
                        Spacer()
                    }
                }
            }
        }
        .onAppear{
            self.copy = self.original
        }
        
    }
}


struct TextEditor_Previews: PreviewProvider {
    static var previews: some View {
        TextEditor(original: .constant("Editor"))
    }
}
