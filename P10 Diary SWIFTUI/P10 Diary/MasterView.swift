//
//  ContentView.swift
//  P10 Diary
//
//  Created by Tom Bastable on 29/11/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationView{
            
            
        List {
            
            NavigationLink(destination: DetailView()) {
                Text("Add New Entry")
            }
            
            Section(header: SearchBar(text: self.$searchQuery)
                .frame(width: 410.0)) {
                
                ForEach(Array(1...100).filter {
                    
                    self.searchQuery.isEmpty ?
                        true :
                        "\($0)".contains(self.searchQuery)
                }, id: \.self) { item in
                    
                    Text("\(item)")
                    
                }
                    
            }
            .padding()
            .frame(height: 55.0)
            
        }
            .navigationBarTitle(Text("Diary Entries"))
            
            
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
