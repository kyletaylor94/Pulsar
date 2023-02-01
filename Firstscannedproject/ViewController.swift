//
//  ViewController.swift
//  Firstscannedproject
//
//  Created by Turdesán Csaba on 2023. 01. 25..
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        
        sceneView.scene.background.contents = UIImage(named: "art.scnassets/8k_stars_milky_way.jpg")
        
        func pulsar(){
            let spehere = SCNSphere(radius: 1.5)
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "art.scnassets/8k_sun.jpg")
            spehere.materials = [material]
            
            material.emission.contents = UIColor.systemCyan
            material.shininess = 20
            
            let materialNode = SCNNode()
            materialNode.geometry = spehere
            let rotateMaterial = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 30)
            let repeatForever = SCNAction.repeatForever(rotateMaterial)
            materialNode.runAction(repeatForever)
            
            let staticNode = SCNNode()
            staticNode.addChildNode(materialNode)
            staticNode.position = SCNVector3(x: -20.5, y: -1.5, z: -0.9)
            
          // beam
            let tube = SCNTube(innerRadius: 0.01, outerRadius: 0.15, height: 30)
            let materialTube = SCNMaterial()
            materialTube.diffuse.contents = UIColor.white
            tube.materials = [materialTube]

            let tubeNode = SCNNode(geometry: tube)
            tubeNode.position = SCNVector3(x: -20.5, y: -1.5, z: -0.9)
            
            
            //rotate beam
            
            let rotate = SCNAction.rotateBy(x: CGFloat(Double.pi), y: 0, z: 0, duration: 0.7)
            let reapetForeverRotate = SCNAction.repeatForever(rotate)
            tubeNode.runAction(reapetForeverRotate)

            //
        
            sceneView.scene.rootNode.addChildNode(staticNode)
            sceneView.scene.rootNode.addChildNode(tubeNode)
            sceneView.automaticallyUpdatesLighting = true
            
            staticNode.filters = addBloom()
            
            tubeNode.filters = addBloom2()
            
        }
        
        //bloom lighting
        func addBloom() -> [CIFilter]? {
            let bloom = CIFilter(name: "CIBloom")!
            bloom.setValue(70, forKey: "inputIntensity")
            bloom.setValue(400, forKey: "inputRadius")
            
            return [bloom]
        }
        
        func addBloom2() -> [CIFilter]? {
            let bloom = CIFilter(name: "CIBloom")!
            bloom.setValue(5, forKey: "inputIntensity")
            bloom.setValue(20, forKey: "inputRadius")
            
            return [bloom]
        }

        sceneView.delegate = self
        
        //call the function
        pulsar()
   
    }
     
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            
            //OBject detection
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
}

