//  ARKit_Sample01_VM.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import Foundation

final class ARKit_Sample01_VM: ObservableObject {
    @Published var isAddedForm = false
    
    func addForm() {
        if isAddedForm == false {
            isAddedForm = true
        }
    }
}
