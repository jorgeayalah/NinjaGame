//
//  HUD.swift
//  NinjaGame
//
//  Created by Jorge Ayala on 11/28/21.
//

import SpriteKit

enum HUDSettings{
    static let score = "Score"
    static let highscore = "Highscore"
    static let tapToStart = "Tap To Start"
    static let gameOver =   """
                            Game
                            Over
                            """
}

class HUD: SKNode {
    
    var scoreLbl: SKLabelNode!
    var highscoreLbl: SKLabelNode!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(_ name: String, text: String, fontSize: CGFloat, pos: CGPoint){
        let label = SKLabelNode()
        label.fontName = fontNamed
        label.name = name
        label.text = text
        label.fontSize = fontSize
        label.position = pos
        label.zPosition = 50.0
        label.zRotation = .pi/2
        addChild(label)
    }
    
    func setupScoreLbl(_ score: Int){
        guard let scene = scene as? GameScene else {return}
//        let pos = CGPoint(x: scene.frame.width - 30, y: 20.0)
        let pos = CGPoint(x: 10.0, y: 140.0)
        addLabel(HUDSettings.score, text: "Score: \(score)", fontSize: 20.0, pos: pos)
        scoreLbl = childNode(withName: HUDSettings.score) as? SKLabelNode
        scoreLbl.zRotation = .pi/2
        scoreLbl.horizontalAlignmentMode = .left
        scoreLbl.verticalAlignmentMode = .top
    }
    
    func setupHighscoreLbl(_ highscore: Int) {
        guard let scene = scene as? GameScene else { return }
        let pos = CGPoint(x: 10.0, y: 700.0)
        addLabel(HUDSettings.highscore, text: "Highscore: \(highscore)", fontSize: 20.0, pos: pos)
        highscoreLbl = childNode(withName: HUDSettings.highscore) as? SKLabelNode
        highscoreLbl.horizontalAlignmentMode = .right
        highscoreLbl.verticalAlignmentMode = .top
    }
    
    func addLbl(fontSize: CGFloat, name: String, text: String){
        guard let scene = scene as? GameScene else {return}
        let pos = CGPoint (x: scene.playableRect.height/2.0, y: scene.playableRect.width/2.0 + 200.0)
        addLabel(name, text: text, fontSize: fontSize, pos: pos)
        
    }
    
    func setupGameState(from: GameState, to: GameState){
        clearUI(gameState: from)
        updateUI(gameState: to)
    }
    
    func updateUI(gameState:  GameState){
        switch gameState{
        case .start:
            addLbl(fontSize: 70.0, name: HUDSettings.tapToStart, text: HUDSettings.tapToStart)
        case .dead:
        addLbl(fontSize: 70.0, name: HUDSettings.gameOver, text: HUDSettings.gameOver)
        default: break
        }
    }
    
    func clearUI(gameState: GameState){
        switch gameState{
        case .start:
            childNode(withName: HUDSettings.tapToStart)?.removeFromParent()
        case .dead:
            childNode(withName: HUDSettings.gameOver)?.removeFromParent()
        default: break
        }
    }
}

