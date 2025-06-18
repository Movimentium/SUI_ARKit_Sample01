//  ARKit_Sample01_VM.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import Foundation

final class ARKit_Sample01_VM: ObservableObject {
    @Published var aRKitViewUpdater = false
    var selectedModelForm = ModelForm.box

    var isAddedForm = false
    var isFormRotating = false

    func addForm() {
        if isAddedForm == false {
            isAddedForm = true
            updateARKitView()
        }
    }
    
    func rotateForm() {
        if isFormRotating == false {
            isFormRotating = true
            updateARKitView()
        }

    }
    
    func removeForm() {
        isFormRotating = false
        isAddedForm = false
        updateARKitView()
    }
    
    private func updateARKitView() {
        aRKitViewUpdater.toggle()
    }
}
