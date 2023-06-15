//
//  KickertrainerApp.swift
//  Kickertrainer
//
//  Created by Dennis Kubousek on 22.03.23.
//

import SwiftUI

@main
struct KickertrainerApp: App {
    let kickertrainer = KickertrainerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: kickertrainer)
        }
    }
}
