//  ModelForm.swift
//  SUI_ARKit_Sample01
//  Created by Miguel Gallego on 18/6/25.
import Foundation
import SceneKit

enum ModelForm: String, Identifiable, CaseIterable {
    case box
    case capsule
    case cone
    case cylinder
    case floor
    case plane
    case pyramid
    case sphere
    case text
    case torus
    case tube

    var geom: SCNGeometry {
        switch self {
        case .box:       SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        case .capsule:   SCNCapsule(capRadius: 0.05, height: 0.2)
        case .cone:     SCNCone(topRadius: 0.05, bottomRadius: 0.1, height: 0.2)
        case .cylinder: SCNCylinder(radius: 1, height: 5)
        case .floor:    SCNFloor() // Vacío
        case .plane:    SCNPlane(width: 0.1, height: 0.1)
        case .pyramid:  SCNPyramid(width: 0.1, height: 0.1, length: 0.1)
        case .sphere:   SCNSphere(radius: 0.1)
        case .text:     SCNText(string: "Hola", extrusionDepth: 0.4)
        case .torus:   SCNTorus(ringRadius: 0.1, pipeRadius: 0.05)
        case .tube:    SCNTube(innerRadius: 0.05, outerRadius: 0.1, height: 0.1)
        }
    }
    
    var aroundRotation: SCNVector3 {
        switch self {
        case .cone, .plane:
            SCNVector3(x: 0, y: 1, z: 1)
        case .text, .pyramid:
            SCNVector3(x: 0, y: 1, z: 0)
        default:
            SCNVector3(x: 1, y: 0, z: 0)
        }
    }
    
    var str: String {
        self.rawValue
    }
    
    var id: Self { self }
}

