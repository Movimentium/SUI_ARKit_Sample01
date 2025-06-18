//  ARKitView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI
import ARKit

struct ARKitView: UIViewRepresentable {
    @EnvironmentObject var vm: ARKit_Sample01_VM

    private let aNode = SCNNode()
    
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
        }
        
    }
    
    private func addPrimitive(_ vwScene: ARSCNView) {
        print(Self.self, #function)
//        let aNode = SCNNode()

        aNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        aNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        aNode.position = SCNVector3(0, 0, -0.3) // A 30cm al frente
        
        vwScene.scene.rootNode.addChildNode(aNode)
    }
    
    private func removeAllNodes(_ vwScene: ARSCNView) {
        vwScene.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }
    
}
