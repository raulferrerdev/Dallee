//
//  DalleeApp.swift
//  Dallee
//
//  Created by Raúl Ferrer on 22/12/22.
//

import SwiftUI

@main
struct DalleeApp: App {
    var body: some Scene {
        WindowGroup {
            DalleeView(viewModel: DalleeViewModel())
        }
    }
}
