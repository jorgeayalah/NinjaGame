//
//  GameViewController.swift
//  NinjaGame
//
//  Created by Alumno on 17/11/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 390, height: 844))
        scene.scaleMode = .aspectFill
        let skView = view as!SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
        

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
