//
//  ScoreGenerator.swift
//  NinjaGame
//
//  Created by Jorge Ayala on 11/29/21.
//

import Foundation

class ScoreGenerator {
    
    static let sharedInstance = ScoreGenerator()
    private init() {}
    
    static let keyHighscore = "keyHighscore"
    
    func setHighscore(_ highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: ScoreGenerator.keyHighscore)
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: ScoreGenerator.keyHighscore)
    }
}
