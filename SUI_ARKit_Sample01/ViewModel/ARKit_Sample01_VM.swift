//  ARKit_Sample01_VM.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import Foundation

final class ARKit_Sample01_VM: ObservableObject {
    @Published var arKitAction = ARKitAction.noAction {
        didSet { print(">didSet arKitAction: ", arKitAction)}
    }
    @Published var selectedModelForm = ModelForm.none {
        willSet {
            if newValue == selectedModelForm {
                arKitAction = .noAction
            } else {
                if newValue == .none {
                    arKitAction = .deleteForm
                } else {
                    isRotateOn = false
                    arKitAction = .addForm(newValue)
                }
            }
        }
        didSet { print(">didSet selectedModelForm: ", selectedModelForm)}
    }
    var isRotateOn = false
    
    func rotateForm() {
        isRotateOn.toggle()
        if selectedModelForm != .none {
            arKitAction = .rotateForm(selectedModelForm, isRotateOn)
        }
    }
    
    func removeForm() {
        selectedModelForm = .none
    }
    
    func handleTap(msg: String){
        print(msg)
    }
}

enum ARKitAction {
    case noAction
    case addForm(ModelForm)
    case deleteForm
    case rotateForm(ModelForm, Bool)
}
