//
//  SettingsScene.swift
//  Descent
//
//  Created by Matthew Mohandiss on 3/3/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    var backButton = SKLabelNode(text: "Back ➤")
    var soundButton = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.whiteColor()
        backButton.position = CGPointMake(self.frame.maxY - 10, self.frame.maxX - 10)
        backButton.fontColor = SKColor.blackColor()
        soundButton.position = CGPointMake(self.frame.midX, self.frame.midY + 50)
        let developerCredits = SKLabelNode(text: "Created By Matthew Mohandiss")
        developerCredits.fontColor = SKColor.blackColor()
        developerCredits.fontSize = 28
        developerCredits.position = CGPointMake(self.frame.midX, self.frame.minY + 85)
        let composerCredits = SKLabelNode(text: "Music By Ramsey Mohandiss")
        composerCredits.position = CGPointMake(self.frame.midX, self.frame.minY + 55)
        composerCredits.fontColor = SKColor.blackColor()
        composerCredits.fontSize = 28
        if playSound { soundButton.texture = SKTexture(imageNamed: "Settings")} //soundOff
        else {soundButton.texture = SKTexture(imageNamed: "Settings")} //soundOn

        self.addChild(soundButton)
        self.addChild(backButton)
        self.addChild(developerCredits)
        self.addChild(composerCredits)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if backButton.containsPoint(location) {
                let scene = MenuScene(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1))
            } else if soundButton.containsPoint(location) {
                toggleSound()
            }
        }
    }
    
    func toggleSound() {
        if playSound {
            playSound = false
            soundButton.texture = SKTexture(imageNamed: "soundOff")
        } else {
            playSound = true
            soundButton.texture = SKTexture(imageNamed: "soundOn")
        }
    }
}
