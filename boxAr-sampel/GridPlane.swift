//
//  GridPlane.swift
//  boxAr-sampel
//
//  Created by JONGWOO JIN on 2020/03/27.
//  Copyright © 2020 JONGWOO JIN. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class GridPlane: SCNNode {
    var anchor : ARPlaneAnchor
    var planGeometry: SCNPlane!
    
    init(anchor : ARPlaneAnchor) {
       self.anchor = anchor
       super.init()
       setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.planGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "overlay_grid.png")
        
        self.planGeometry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planGeometry)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        
        self.addChildNode(planeNode)
    }
}
