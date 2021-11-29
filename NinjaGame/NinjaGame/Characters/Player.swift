//
//  Player.swift
//  NinjaGame
//
//  Created by Alumno on 18/11/21.
//

import SpriteKit

class Player: SKSpriteNode{
    init(){
        let texture = SKTexture(imageNamed: "player1")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Player"
        zPosition = 1.0
        zRotation = .pi/2
        setScale(0.25)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.Wall
        physicsBody!.contactTestBitMask = PhysicsCategory.Wall | PhysicsCategory.Score
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Player{
    func setupPlayer(_ ground: Ground, scene: SKScene){
        position = CGPoint(x: scene.frame.width/2 - ground.frame.height * 0.75, y: scene.frame.height/2 - 25.0)
        scene.addChild(self)
        setupAnim()
    }
    func setupAnim(){
        var textures: [SKTexture] = []
        
        for i in 1...2{
            textures.append(SKTexture(imageNamed: "player\(i)"))
        }
        run(.repeatForever(.animate(with: textures, timePerFrame: 0.10)))
    }
}
