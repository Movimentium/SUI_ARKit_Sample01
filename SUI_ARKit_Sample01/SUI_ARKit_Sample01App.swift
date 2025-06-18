//  SUI_ARKit_Sample01App.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI

@main
struct SUI_ARKit_Sample01App: App {
    @StateObject var vm = ARKit_Sample01_VM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
