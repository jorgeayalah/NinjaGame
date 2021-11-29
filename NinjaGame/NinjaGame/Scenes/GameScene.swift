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
    var hud = HUD()
    
    var moveSpeed: CGFloat = 8.0
    var wallTimer: Timer?
    var cloudTimer: Timer?
    
    
    var numScore = 0
    
    var playableRect: CGRect {
        let ratio: CGFloat
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            ratio = 2.16
        default:
            ratio = 16/9
        }
        
        let playableHeight = size.height / ratio
        let playableMargin = (size.width - playableHeight) / 2.0
        
        return CGRect(x: playableMargin, y: 0.0, width: playableHeight, height: size.width)
    }
    
    var gameState: GameState = .initial {
        didSet {
            hud.setupGameState(from: oldValue, to: gameState)
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(rgb: 0xB3E5FC)
        setupNodes()
        setupPhysics()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        
        if node.name == HUDSettings.tapToStart {
            gameState = .play
            isPaused = false
            setupTimer()
            
        } else if node.name == HUDSettings.gameOver {
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            view!.presentScene(scene, transition: .fade(withDuration: 0.5))
            
        } else {
            playerNode.setupMoveUpDown()
        }
        //playerNode.setupMoveUpDpwn()
    }
    override func update(_ currentTime: TimeInterval) {
        if gameState != .play {
            isPaused = true
            return
        }
        
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
        var wallRandom = CGFloat.random(min: 1.5, max: 2.5)
        run(.repeatForever(.sequence([.wait(forDuration: 5.0), .run{
            wallRandom -= 1.0
        }])))
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
        
        //Wall
        let wall = SKSpriteNode(imageNamed: "block").copy() as! SKSpriteNode
        wall.name = "Block"
        wall.zPosition = 2.0
        //let value: CGFloat = (wall.frame.width + groundNode.frame.height * 0.5)/2.0
        wall.size.height = wall.frame.height * 0.4
        wall.size.width = wall.frame.width * 0.4
        wall.position = CGPoint(x: frame.width/2 + (wall.frame.width + groundNode.frame.height * 0.5)/2 * scale,
                                y: size.height + wall.frame.height)
//        let wallPosX = frame.width/2 + value * scale
//        wall.position = CGPoint(x: wallPosX,
//                                y: size.height + wall.frame.height)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody!.isDynamic = false
        wall.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        
        addChild(wall)
        wall.run(.sequence([.wait(forDuration: 8.0), .removeFromParent()]))
        
        //Score
        let score = SKSpriteNode(texture: nil, color: .green, size: CGSize(width: 50.0, height: 50.0)).copy() as! SKSpriteNode
        score.name = "Score"
        score.zPosition = 5.0
        score.size.height = score.frame.height * 0.4
        score.size.width = score.frame.width * 0.4
        let scorePosX = frame.width/2 + (wall.frame.width + groundNode.frame.height * 0.5)/2 * (-scale)
        //score.position = CGPoint(x: scorePosX, y: wall.position.y + score.frame.width)
        score.position = CGPoint(x: scorePosX, y: wall.position.y + score.frame.width)
        score.physicsBody = SKPhysicsBody(rectangleOf: score.size)
        score.physicsBody!.isDynamic = false
        score.physicsBody!.categoryBitMask = PhysicsCategory.Score
        addChild(score)
    }
    func moveWall(){
        enumerateChildNodes(withName: "Block") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= self.moveSpeed
        }
        enumerateChildNodes(withName: "Score") { (node, _) in
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
    func setupHUD() {
        addChild(hud)
        hud.setupScoreLbl(numScore)
        hud.setupHighscoreLbl(ScoreGenerator.sharedInstance.getHighscore())
    }
    func gameOver() {
        playerNode.removeFromParent()
        wallTimer?.invalidate()
        cloudTimer?.invalidate()
        gameState = .dead
        isPaused = true
        
        let highscore = ScoreGenerator.sharedInstance.getHighscore()
        if numScore > highscore {
            ScoreGenerator.sharedInstance.setHighscore(numScore)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        switch other.categoryBitMask{
        case PhysicsCategory.Wall:
            print("Wall")
            gameOver()
        case PhysicsCategory.Score:
            if let node = other.node{
                numScore += 1
                hud.scoreLbl.text = "Score: \(numScore)"
                if numScore % 5 == 0{
                    moveSpeed += 1.0
                }
                node.removeFromParent()
            }
        default: break
        }
    }
}
