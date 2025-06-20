//  ARKitView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI
import ARKit

struct ARKitView: UIViewRepresentable {
    @EnvironmentObject var vm: ARKit_Sample01_VM
    private var isActionInProgress = false
    
    func makeUIView(context: Context) -> some UIView {
        print(Self.self, #function)
        let vwScene = ARSCNView()
        let tapGestRecog = UITapGestureRecognizer(target: context.coordinator, 
                                                  action: #selector(Coordinator.handleTap))
        vwScene.addGestureRecognizer(tapGestRecog)
        // vwScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        vwScene.autoenablesDefaultLighting = true
        let configuration = ARWorldTrackingConfiguration()
        vwScene.session.run(configuration)
        
        return vwScene
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print(Self.self, #function)
        guard let vwScene = uiView as? ARSCNView else {
            print(Self.self, #function, "ERROR!!")
            return
        }
        
        switch vm.arKitAction {
        case .noAction:
            print(".noAction")
            return
        case .addForm(let modelForm):
            removeAllNodes(vwScene)
            addPrimitive(vwScene, modelForm: modelForm)
        case .deleteForm:
            removeAllNodes(vwScene)
        case let .rotateForm(modelForm, isOn):
            rotateForm(vwScene, modelForm: modelForm, isOn: isOn)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(vm: vm)
    }
    
    private func addPrimitive(_ vwScene: ARSCNView, modelForm: ModelForm) {
        print(Self.self, #function)
        let aNode = SCNNode()
        aNode.geometry = modelForm.geom
        if modelForm != .laTierra {
            aNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            aNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        }
        aNode.position = SCNVector3(0, 0, -0.3) // A 30cm al frente
        aNode.name = modelForm.str
        vwScene.scene.rootNode.addChildNode(aNode)
    }
    
    private func removeAllNodes(_ vwScene: ARSCNView) {
        print(Self.self, #function)
        vwScene.scene.rootNode.childNodes.forEach {
            $0.removeAllActions()
            $0.removeFromParentNode()
        }
    }
    
    private func rotateForm(_ vwScene: ARSCNView, modelForm: ModelForm, isOn: Bool) {
        print(Self.self, #function)
        if isOn == false {
            vwScene.scene.rootNode.childNodes.forEach { $0.removeAllActions() }
            return
        }
        let rotation = SCNAction.rotate(by: 2 * .pi, // radians
                                        around: modelForm.aroundRotation,
                                        duration: 5)
        let repeatRotation = SCNAction.repeatForever(rotation)
        let nameToSearch = modelForm.str
        vwScene.scene.rootNode.childNodes.forEach {
            if $0.name == nameToSearch {
                $0.runAction(repeatRotation)
            }
        }
    }
    
    class Coordinator: NSObject {
        var vm: ARKit_Sample01_VM
        
        init(vm: ARKit_Sample01_VM) {
            self.vm = vm
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let vwScene = sender.view as? ARSCNView else { return }
            let pnt = sender.location(in: vwScene)
            let hitTest = vwScene.hitTest(pnt)
            if let aNode = hitTest.first?.node {
                vm.handleTap(msg: "Se ha tocado el nodo: \(aNode.name ?? "")")
            } else {
                vm.handleTap(msg: "No se ha tocado un nodo")
            }
        }
        
    }
    
}
