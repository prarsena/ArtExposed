//
//  ContentView.swift
//  ArtExposed
//
//  Created by petera on 6/15/23.
//

/*
 https://collectionapi.metmuseum.org/public/collection/v1/search?artistOrCulture=true&q=Gogh
 https://collectionapi.metmuseum.org/public/collection/v1/objects/437984
 */

import SwiftUI

struct ContentView: View {
    @State private var query: String = ""
    @State private var responseData: [String] = []
    @State private var error: Bool = false
    @State private var boolSwitch: Bool = false

    var body: some View {
        VStack {
            TextField("Enter query", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Send Request") {
                sendRequest()
                boolSwitch.toggle();
            }
            .padding()
            
            Text(String(boolSwitch)).hidden()

            if !responseData.isEmpty {
                //ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(responseData, id: \.self) { item in
                            Text(item)
                        }
                    }
                //}
            } else if error {
                Text("No data returned")
            }
        }
        .padding()
    }

    func sendRequest() {
        if (query != ""){
            //let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isOnView=true&artistOrCulture=true&q=\(query)"
            let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/search?artistOrCulture=true&q=\(query)"
            guard let url = URL(string: urlString) else {
                return
            }

            URLSession.shared.dataTask(with: url) { (data, _, _) in
                DispatchQueue.main.async {
                    if let data = data {
                        if let response = String(data: data, encoding: .utf8) {
                            let items = response.components(separatedBy: "\n").prefix(10)
                            responseData = Array(items)
                            print(responseData)
                            boolSwitch.toggle()
                        }
                    } else {
                        error = true
                    }
                }
            }
            .resume()
        } else {
            print("no dicee")
        }
    
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
