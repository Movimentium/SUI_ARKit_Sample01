//  ContentView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ARKit_Sample01_VM
    
    var body: some View {
        VStack {
            ARKitView()
                .border(.red)
            Button {
                vm.addForm()
            } label: {
                Text("Añadir forma")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ARKit_Sample01_VM())
}
