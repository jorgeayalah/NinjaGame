//
//  Player.swift
//  NinjaGame
//
//  Created by Alumno on 18/11/21.
//

import SpriteKit

class Player: SKSpriteNode{
    
    var isMoveDown = false
    
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
        //position = CGPoint(x: scene.frame.width/2 - ground.frame.height * 0.5, y: scene.frame.height/2 - 25.0)
        position = CGPoint(x: scene.frame.width/2 - ground.size.height + 10.0, y: scene.frame.height/2 - 30.0)
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
    func setupMoveUpDown(){
        isMoveDown = !isMoveDown
        let scale: CGFloat
        if isMoveDown{
            scale = 0.25
        }else{
            scale = -0.25
        }
        
        let flipY  = SKAction.scaleY(to: (scale * -1.0), duration: 0.1)
        run(flipY)
        let moveBy = SKAction.moveBy(x: scale*3.6*(frame.height*2.6), y: 0.0, duration: 0.1)
        //let moveBy = SKAction.moveBy(x: 0.0, y: scale*(frame.width*2.6), duration: 0.1)
        run(moveBy)
    }
}
