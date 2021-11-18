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
}
