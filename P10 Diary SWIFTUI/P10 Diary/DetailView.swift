//
//  DetailView.swift
//  P10 Diary
//
//  Created by Tom Bastable on 29/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @State var name: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Your Diary Entry:")
            TextField(" Enter some text", text: $name)
                .frame(height: 300.0)
                .shadow(radius: 10)
            
            HStack {
                Button(action: {}) {
                Text("Add Location to Diary Entry")
                }
                Spacer()
                Button(action: {}) {
                Text("Add Photos")
                }
            }
        }
        .padding(.horizontal)
        
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
