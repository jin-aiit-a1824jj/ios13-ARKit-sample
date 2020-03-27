//
//  ViewController.swift
//  boxAr-sampel
//
//  Created by JONGWOO JIN on 2020/03/27.
//  Copyright © 2020 JONGWOO JIN. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private let lable = UILabel()
    private var planes = [GridPlane]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.view.addSubview(self.sceneView)
        
        self.lable.frame = CGRect(x: 0, y: 0, width: self.sceneView.frame.size.width, height: 50)
        self.lable.center = self.sceneView.center
        self.lable.textAlignment = .center
        self.lable.textColor = UIColor.red
        self.lable.font = UIFont.preferredFont(forTextStyle: .headline)
        self.lable.alpha = 0
        self.sceneView.addSubview(self.lable)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()

        //addObject(scene: scene)
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    func addObject(scene: SCNScene) {
                let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
                let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: "block.jpg")

                let node = SCNNode()
                node.geometry = box
                node.geometry?.materials = [material]
                node.position = SCNVector3(0, 0.2, -0.5)
                
                scene.rootNode.addChildNode(node)

                //
                let textGeometry = SCNText(string: "Hello Swift", extrusionDepth: 1.0)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.orange
                
                let textNode = SCNNode(geometry: textGeometry)
                textNode.position = SCNVector3(0, 0.1, -0.6)
                textNode.scale = SCNVector3(0.02, 0.02, 0.02)
                scene.rootNode.addChildNode(textNode)
                
                //
                let sphere = SCNSphere(radius: 0.2)
                
                let sphereMaterial = SCNMaterial()
                sphereMaterial.diffuse.contents = UIImage(named: "earth.jpg")
                
                let sphereNode = SCNNode(geometry: sphere)
                sphereNode.geometry?.materials = [sphereMaterial]
                sphereNode.position = SCNVector3(0.4, 0.1, -1)
                scene.rootNode.addChildNode(sphereNode)
            
                
                //
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
                self.sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func tapped(recognizer: UIGestureRecognizer){
        let sceneView = recognizer.view as! SCNView
        let touhchLocation = recognizer.location(in: sceneView)
        let hitResult = sceneView.hitTest(touhchLocation, options: [:])
        
        if !hitResult.isEmpty {
            let node = hitResult[0].node
//            node.geometry?.materials.forEach { m  in
//                print(m.name as Any)
//            }
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
             node.geometry?.materials = [material]
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor){
            return
        }
        let plane = GridPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
        
        DispatchQueue.main.async {
            self.lable.text = "Plane Detected!"
            UIView.animate(withDuration: 3.0, animations: {self.lable.alpha = 1.0}, completion: { over in self.lable.alpha = 0.0})
        }
    }
    
}
