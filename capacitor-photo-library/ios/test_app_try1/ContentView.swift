//
//  ContentView.swift
//  test_app_try1
//
//  Created by Nick Pisani on 1/6/21.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Capacitor
import Plugin
import Photos

import SwiftUI

struct ContentView: View {
    var body: some View {
        //runTest1()
        return  VStack {
            Text("TEST")
                    .font(.title)
            Button(action: {
                self.runSomething()
            }) {
                Text("CLICK")
            }
        }

    }

    func runSomething() {
        let plugin = PhotoLibrary()
        print("beginning test")
        let call = CAPPluginCall(callbackId: "test", options: [
            "mode": "fast",
            "limit": 2,
            "imageType": "png"
        ], success: { (result, _) in
            let totalValue = result!.data["total"] as? Int
            let allImages = result!.data["images"] as? [[String: Any]]
            print("in success!")
            print("totalValue", totalValue!)
            print("allImages", allImages!)
            print("firstImage", allImages![0])
        }, error: { (err: Optional<CAPPluginCallError>) in
            print(Thread.callStackSymbols)
            print("inside error!!! \(err!)")
        })
        plugin.getPhotos(call!)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
