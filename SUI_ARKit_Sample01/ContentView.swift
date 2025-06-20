//  ContentView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ARKit_Sample01_VM
    
    var body: some View {
        VStack {
            ARKitView()
            HStack {
                Picker("Forma", selection: $vm.selectedModelForm) {
                    ForEach(ModelForm.allCases) { form in
                        Text(form.str).tag(form)
                    }
                }
                Button("Rotar") {
                    vm.rotateForm()
                }
                Button("Borrar") {
                    vm.removeForm()
                }
                .tint(.red)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContentView()
        .environmentObject(ARKit_Sample01_VM())
}
