//
//  MenuScene.swift
//  ColorColorFunTime
//
//  Created by Matthew Mohandiss on 2/5/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit
import iAd
import GameKit

var localPlayer = GKLocalPlayer()

class MenuScene: SKScene {
    var title = SKLabelNode(text: "Descent")
    var playButton = SKLabelNode(text: "Play")
    var playButtonHitBox = SKShapeNode()
    var settingsButton = SKSpriteNode(imageNamed: "Settings")
    var leaderboardsButton = SKSpriteNode(imageNamed: "Leaderboards")
    
    override func didMove(to view: SKView) {
        authenticateLocalPlayer()
        
        self.run(SKAction.wait(forDuration: 0.8), completion: {adBannerView?.isHidden = false})
        self.backgroundColor = SKColor.white
        
        title.fontSize = 40
        title.fontColor = SKColor.black
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        
        playButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        playButton.fontColor = SKColor.black
        playButtonHitBox = SKShapeNode(rectOf: CGSize(width: playButton.frame.width + 60, height: playButton.frame.height + 40 ))
        playButtonHitBox.position = CGPoint(x: playButton.position.x, y: playButton.position.y + playButton.frame.height/2)
        
        settingsButton.setScale(0.75)
        settingsButton.anchorPoint = CGPoint.zero
        settingsButton.position = CGPoint(x: self.frame.minX + 10, y: self.frame.minY + 25)
        
        leaderboardsButton.setScale(0.75)
        leaderboardsButton.anchorPoint = CGPoint(x: 1, y: 0)
        leaderboardsButton.position = CGPoint(x: self.frame.maxX - 10, y: self.frame.minY + 25)
        
        if let time = self.userData?.value(forKey: "Time") as? Double {
            
            let savedScore = getHighScore()
            var displayTime = NSString(format: "%.1f", time)
            if savedScore != nil {
                reportScore()
                displayTime = NSString(format: "%.1f", savedScore!)
            }
            
        let timeLabel = SKLabelNode(text: "Last Game: \(displayTime) seconds!")
            timeLabel.fontColor = SKColor.black
            timeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
            self.addChild(timeLabel)
        }
        
        self.addChild(title)
        self.addChild(playButton)
        self.addChild(playButtonHitBox)
        self.addChild(settingsButton)
        self.addChild(leaderboardsButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if playButtonHitBox.contains(location) {
                let scene = GameScene(size: self.size)
                adBannerView?.isHidden = true
                print("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.up, duration: 1))
            } else if settingsButton.contains(location) {
                let scene = SettingsScene(size: self.size)
                //adBannerView.hidden = true
                //println("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 1))
            } else if leaderboardsButton.contains(location) {
                let scene = LeaderBoardsScene(size: self.size)
                //adBannerView.hidden = true
                //println("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 1))
                print(self.frame)
            }
        }

    }
    
    func getHighScore() -> Int64? {
        return UserDefaults.standard.object(forKey: "Time") as? Int64
    }
    
    func reportScore() {
        let score = GKScore(leaderboardIdentifier: "AllScores")
        score.value = getHighScore()!
        GKScore.report([score], withCompletionHandler: { error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Reported New Score")
            }
        })
    }
    
    func authenticateLocalPlayer(){
        localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {viewController, error in
            
            if viewController != nil {
                self.view?.window?.rootViewController?.present(viewController!, animated: true, completion: nil)
                print("Local Player Being Authenticated")
            }
            else if localPlayer.isAuthenticated {
                print("Local Player Authenticated")
            }
            else {
                print("Local Player Not Authenticated")
            }
        }
    }
    
}
