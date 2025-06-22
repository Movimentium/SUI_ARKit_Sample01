//  ARKitView.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import SwiftUI
import ARKit

struct ARKitView: UIViewRepresentable {
    @EnvironmentObject var vm: ARKit_Sample01_VM
    
    func makeCoordinator() -> Coordinator {
        print(Self.self, #function)
        return Coordinator(vm: vm)
    }
    
    func makeUIView(context: Context) -> some UIView {
        print(Self.self, #function)
        let vwScene = ARSCNView()
        vwScene.autoenablesDefaultLighting = true
        // vwScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        let oneTapRecog = UITapGestureRecognizer(target: context.coordinator,
                                                 action: #selector(Coordinator.handleOneTap))
        let doubleTapRecog = UITapGestureRecognizer(target: context.coordinator,
                                                    action: #selector(Coordinator.handleDoubleTap))
        oneTapRecog.numberOfTapsRequired = 1
        doubleTapRecog.numberOfTapsRequired = 2
        oneTapRecog.require(toFail: doubleTapRecog)
        vwScene.addGestureRecognizer(oneTapRecog)
        vwScene.addGestureRecognizer(doubleTapRecog)
        vwScene.session.run(ARWorldTrackingConfiguration())
        
        return vwScene
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print(Self.self, #function)
        guard let vwScene = uiView as? ARSCNView else { return }
        
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
        case .restartSession:
            restartSession(vwScene)
        }
    }

    // MARK: - Private methods
    
    private func addPrimitive(_ vwScene: ARSCNView, modelForm: ModelForm) {
        print(Self.self, #function)
        let aNode = SCNNode()
        aNode.geometry = modelForm.geom
        if modelForm != .laTierra && modelForm != .planeta {
            aNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            aNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        }
        aNode.position = SCNVector3(0, 0, vm.originalZposition) // A 30cm al frente
        aNode.name = modelForm.str
        vwScene.scene.rootNode.addChildNode(aNode)
    }
    
    private func removeAllNodes(_ vwScene: ARSCNView) {
        print(Self.self, #function)
        vwScene.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
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
                return
            }
        }
    }
    
    private func restartSession(_ vwScene: ARSCNView) {
        print(Self.self, #function)
        vwScene.session.pause()
        vwScene.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        vwScene.session.run(ARWorldTrackingConfiguration(),
                            options: [.resetTracking, .removeExistingAnchors])
    }
    
    class Coordinator: NSObject {
        var vm: ARKit_Sample01_VM
        
        init(vm: ARKit_Sample01_VM) {
            self.vm = vm
        }
        
        @objc func handleOneTap(_ sender: UITapGestureRecognizer) {
            guard let vwScene = sender.view as? ARSCNView else { return }
            let pnt = sender.location(in: vwScene)
            let hitTest = vwScene.hitTest(pnt)
            if let aNode = hitTest.first?.node {
                print("Se ha tocado el nodo: \(aNode.name ?? "")")
                let moveAction = SCNAction.moveBy(x: 0, y: 0, z: -0.2, duration: 0.5)
                moveAction.timingMode = .easeInEaseOut
                aNode.runAction(moveAction)
            }
        }
        
        @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
            guard let vwScene = sender.view as? ARSCNView else { return }
            let pnt = sender.location(in: vwScene)
            let hitTest = vwScene.hitTest(pnt)
            if let aNode = hitTest.first?.node {
                print("Se ha tocado el nodo: \(aNode.name ?? "")")
                let pntOrigin = SCNVector3(0, 0, vm.originalZposition)
                let moveBackAction = SCNAction.move(to: pntOrigin, duration: 0.5)
                moveBackAction.timingMode = .easeInEaseOut
                aNode.runAction(moveBackAction)
            }
        }
    }
    
}
