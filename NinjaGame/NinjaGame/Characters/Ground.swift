//
//  Ground.swift
//  NinjaGame
//
//  Created by Alumno on 17/11/21.
//

import SpriteKit

class Ground: SKSpriteNode{
    init(){
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Ground"
        zPosition = -1.0
        anchorPoint = CGPoint(x: 0, y: 0.5)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension Ground{
    func setupGround(_ scene: SKScene){
        for i in 0...2{
            let ground = Ground()
            ground.position = CGPoint(x: scene.frame.size.width/2.0, y: CGFloat(i)*ground.frame.width)
            ground.zRotation = .pi/2
            ground.size.height = ground.frame.width * 0.75
            print(ground.position)
            print(scene.frame.size)
            scene.addChild(ground)
        }
    }
    func moveGround(_ scene: GameScene){
        scene.enumerateChildNodes(withName: "Ground") { (node, _) in
            let node = node as! SKSpriteNode
            
            node.position.y -= scene.moveSpeed
            if node.position.y < -scene.frame.height{
                node.position.y += scene.frame.height/2
            }
        }
    }
}
