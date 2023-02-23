//
//  ZaehlerApp.swift
//  Zaehler
//
//  Created by Hauke Marquard on 23.02.23.
//

import SwiftUI

@main
struct ZaehlerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MeterListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
