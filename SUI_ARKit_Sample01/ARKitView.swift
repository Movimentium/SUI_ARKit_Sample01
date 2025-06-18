//  ARKitView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI
import ARKit

struct ARKitView: UIViewRepresentable {
    @EnvironmentObject var vm: ARKit_Sample01_VM
    
    func makeUIView(context: Context) -> some UIView {
        print(Self.self, #function)
        let vwScene = ARSCNView()
        vwScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
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

        if vm.isAddedForm {
            addPrimitive(vwScene)
        } else {
            removeAllNodes(vwScene)
        }
        if vm.isFormRotating {
            rotateForm(vwScene)
        }
    }
    
    private func addPrimitive(_ vwScene: ARSCNView) {
        print(Self.self, #function)
        let aNode = SCNNode()

        aNode.geometry = vm.selectedModelForm.geom
        aNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        aNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        aNode.position = SCNVector3(0, 0, -0.3) // A 30cm al frente
        aNode.name = vm.selectedModelForm.str
        
        vwScene.scene.rootNode.addChildNode(aNode)
    }
    
    private func removeAllNodes(_ vwScene: ARSCNView) {
        vwScene.scene.rootNode.childNodes.forEach {
            $0.removeAllActions()
            $0.removeFromParentNode()
        }
    }
    
    private func rotateForm(_ vwScene: ARSCNView) {
        let rotation = SCNAction.rotate(by: 90 * .pi / 180,
                                        around:  vm.selectedModelForm.aroundRotation,
                                        duration: 3)
        let repeatRotation = SCNAction.repeatForever(rotation)
        let nameToSearch = vm.selectedModelForm.str
        vwScene.scene.rootNode.childNodes.forEach {
            if $0.name == nameToSearch {
                $0.runAction(repeatRotation)
            }
        }
    }
    
}
