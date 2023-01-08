//
//  ViewController.swift
//  ARDicee
//
//  Created by qbuser on 06/01/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBAction func Roll(_ sender: Any) {
rollAll()
    }

    @IBOutlet var sceneView: ARSCNView!
    var diceNode = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showBoundingBoxes]
        
        // Create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //
        //        // Set the scene to the view
        //        sceneView.scene = scene
        
        //        let Sphere = SCNSphere(radius: 0.2)
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpeg")
        //        Sphere.materials = [material]
        //
        //        let node = SCNNode()
        //        node.position = SCNVector3(0, 0.2, -0.5)
        //        node.geometry = Sphere
        //        sceneView.scene.rootNode.addChildNode(node)
        //        sceneView.autoenablesDefaultLighting = true
        
        //        let scene  = SCNScene(named: "art.scnassets/diceCollada.scn")!
        //        if let node = scene.rootNode.childNode(withName: "Dice", recursively: true){
        //            node.position = SCNVector3(0, 0, -0.1)
        //            sceneView.scene.rootNode.addChildNode(node)
        //
        //        }
        
        //sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        //    configuration.planeDetection = .vertical
        
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node : SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")!
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            
            node.addChildNode(planeNode)
            
        }else {
            return
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlane)
            if let hitResults = results.first{
                let scene  = SCNScene(named: "art.scnassets/diceCollada.scn")!
                if let node = scene.rootNode.childNode(withName: "Dice", recursively: true){
                    node.position = SCNVector3(hitResults.worldTransform.columns.3.x, hitResults.worldTransform.columns.3.y+node.boundingSphere.radius, hitResults.worldTransform.columns.3.z)
                    diceNode.append(node)
                    sceneView.scene.rootNode.addChildNode(node)
                }
            }
            
        }
    }
    func rollAll () {
        if !diceNode.isEmpty {
            for dice in diceNode {
                roll(dice : dice)
            }
        }
    }
    func roll (dice : SCNNode){
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 1))

    }
}
