//
//  GameScene.swift
//  NinjaGame
//
//  Created by Alumno on 17/11/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var groundNode = Ground()
    var playerNode = Player()
    var moveSpeed: CGFloat = 8.0
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(rgb: 0xB3E5FC)
        setupNodes()
    }
    override func update(_ currentTime: TimeInterval) {
        groundNode.moveGround(self)
    }
}
extension GameScene{
    func setupNodes(){
        groundNode.setupGround(self)
        playerNode.setupPlayer(groundNode, scene: self)
        
    }
    
    func spawnWalls(){
        let scale: CGFloat
        if Int(arc4random_uniform(UInt32(2))) == 0{
            scale = -1.0
        }else{
            scale = 1.0
        }
        let wall = SKSpriteNode(imageNamed: "block").copy() as! SKSpriteNode
        wall.name = "Block"
        wall.zPosition = 2.0
        wall.position = CGPoint(x: size.width + wall.frame.width, y: frame.height/2 + (wall.frame.height + groundNode.frame.height)/2 * scale)
    }
}
