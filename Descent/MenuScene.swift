//
//  MenuScene.swift
//  ColorColorFunTime
//
//  Created by Matthew Mohandiss on 2/5/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit
import iAd

class MenuScene: SKScene {
    var title = SKLabelNode(text: "Descent")
    var playButton = SKLabelNode(text: "Play")
    var playButtonHitBox = SKShapeNode()
    var settingsButton = SKSpriteNode(imageNamed: "Settings")
    
    override func didMoveToView(view: SKView) {
        self.runAction(SKAction.waitForDuration(0.8), completion: {adBannerView.hidden = false})
        self.backgroundColor = SKColor.whiteColor()
        
        title.fontSize = 40
        title.fontColor = SKColor.blackColor()
        title.position = CGPointMake(self.frame.midX, self.frame.midY + 100)
        
        playButton.position = CGPointMake(self.frame.midX, self.frame.midY)
        playButton.fontColor = SKColor.blackColor()
        playButtonHitBox = SKShapeNode(rectOfSize: CGSizeMake(playButton.frame.width + 60, playButton.frame.height + 40 ))
        playButtonHitBox.position = CGPointMake(playButton.position.x, playButton.position.y + playButton.frame.height/2)
        
        settingsButton.setScale(0.75)
        settingsButton.anchorPoint = CGPointZero
        settingsButton.position = CGPointMake(10, 55)
        
        if let time = self.userData?.valueForKey("Time") as? Double {
            
            let savedScore = getHighScore()
            var displayTime = NSString(format: "%.1f", time)
            if savedScore != nil {
                displayTime = NSString(format: "%.1f", savedScore!)
            }
            
        let timeLabel = SKLabelNode(text: "You Lasted \(displayTime) seconds!")
            timeLabel.fontColor = SKColor.blackColor()
            timeLabel.position = CGPointMake(self.frame.midX, self.frame.midY - 100)
            self.addChild(timeLabel)
        }
        
        self.addChild(title)
        self.addChild(playButton)
        self.addChild(playButtonHitBox)
        self.addChild(settingsButton)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if playButtonHitBox.containsPoint(location) {
                let scene = GameScene(size: self.size)
                adBannerView.hidden = true
                println("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: 1))
            } else if settingsButton.containsPoint(location) {
                let scene = SettingsScene(size: self.size)
                adBannerView.hidden = true
                println("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1))
            }
        }

    }
    
    func getHighScore() -> Double? {
        return NSUserDefaults.standardUserDefaults().objectForKey("score") as? Double
    }
}
