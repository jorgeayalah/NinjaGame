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
    var cloud = Cloud()
    
    var moveSpeed: CGFloat = 8.0
    var wallTimer: Timer?
    var cloudTimer: Timer?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(rgb: 0xB3E5FC)
        setupNodes()
        setupPhysics()
    }
    override func update(_ currentTime: TimeInterval) {
        groundNode.moveGround(self)
        moveWall()
        cloud.moveCloud(self)
    }
}
extension GameScene{
    func setupNodes(){
        groundNode.setupGround(self)
        playerNode.setupPlayer(groundNode, scene: self)
        cloud.setupClouds()
        setupTimer() // to spawn walls
    }
    func setupPhysics(){
        physicsWorld.contactDelegate = self
    }
    func setupTimer(){
        let wallRandom = CGFloat.random(min: 1.5, max: 2.5)
        wallTimer = Timer.scheduledTimer(timeInterval: TimeInterval(wallRandom), target: self, selector: #selector(spawnWalls), userInfo: nil, repeats: true)
        let cloudRandom = CGFloat.random(min: 3.5, max: 6.5)
        cloudTimer = Timer.scheduledTimer(timeInterval: TimeInterval(cloudRandom), target: self, selector: #selector(spawnClouds), userInfo: nil, repeats: true)
    }
    
    @objc func spawnWalls(){
        let scale: CGFloat
        if Int(arc4random_uniform(UInt32(2))) == 0{
            scale = -1.0
        }else{
            scale = 1.0
        }
        let wall = SKSpriteNode(imageNamed: "block").copy() as! SKSpriteNode
        wall.name = "Block"
        wall.zPosition = 2.0
        wall.size.height = wall.frame.height * 0.4
        wall.size.width = wall.frame.width * 0.4
        //wall.position = CGPoint(x: size.width + wall.frame.width, y: frame.height/2 + (wall.frame.height + groundNode.frame.height)/2 * scale)
        wall.position = CGPoint(x: frame.width/2 + (wall.frame.width + groundNode.frame.height * 0.75)/2 * scale,
                                y: size.height + wall.frame.height)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody!.isDynamic = false
        wall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        addChild(wall)
        wall.run(.sequence([.wait(forDuration: 8.0), .removeFromParent()]))
    }
    func moveWall(){
        enumerateChildNodes(withName: "Block") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= self.moveSpeed
        }
    }
    @objc func spawnClouds(){
        let index = Int(arc4random_uniform(UInt32(cloud.clouds.count - 1)))
        let cloud = self.cloud.clouds[index].copy() as! Cloud
        //let randomY = CGFloat.random(min: -cloud.frame.height, max: cloud.frame.height * 2.0)
        let randomX = CGFloat.random(min: -cloud.frame.height, max: cloud.frame.height * 2.0)
        //cloud.position = CGPoint(x: frame.width + cloud.frame.width, y: randomY)
        cloud.position = CGPoint(x: randomX, y: frame.height + cloud.frame.width)
        cloud.zRotation = .pi/2
        addChild(cloud)
        cloud.run(.sequence([.wait(forDuration: 15.0), .removeFromParent()]))
    }
    func gameOver(){
        playerNode.removeFromParent()
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        switch other.categoryBitMask{
        case PhysicsCategory.Wall:
            print("Wall")
            gameOver()
        default: break
        }
    }
}
