//
//  Cloud.swift
//  NinjaGame
//
//  Created by Alumno on 25/11/21.
//

import SpriteKit

class Cloud: SKSpriteNode {
    var clouds: [Cloud] = []
    
    func setupClouds(){
        for i in 1...3{
            let cloud = Cloud(imageNamed: "cloud\(i)")
            cloud.name = "Cloud"
            cloud.zPosition = -5.0
            //zRotation = .pi/2
            cloud.alpha = 0.5
            cloud.setScale(1.0)
            clouds.append(cloud)
        }
    }
    func moveCloud(_ scene: SKScene){
        scene.enumerateChildNodes(withName: "Cloud") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= 3.0 // the clouds move slower than the rest of nodes
        }
    }
}
