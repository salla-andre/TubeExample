//
//  TubeExampleApp.swift
//  BallSort
//
//  Created by André Salla on 20/06/24.
//

import SwiftUI

@main
struct TubeExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
