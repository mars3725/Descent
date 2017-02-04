//
//  SettingsScene.swift
//  Descent
//
//  Created by Matthew Mohandiss on 3/3/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    var backButton = SKLabelNode(text: "Back ▶︎")
    var soundButton = SKSpriteNode()
    var developerCredits = SKLabelNode(text: "Created By Matthew Mohandiss")
    var composerCredits = SKLabelNode(text: "Music By Ramsey Mohandiss")
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
        backButton.position = CGPoint(x: self.frame.maxX - 55, y: self.frame.maxY - (30 + (adBannerView?.frame.height)!))
        backButton.fontColor = SKColor.black
        soundButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        
        developerCredits.fontColor = SKColor.black
        developerCredits.fontSize = 28
        developerCredits.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 85)
        
        composerCredits.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 55)
        composerCredits.fontColor = SKColor.black
        composerCredits.fontSize = 28
        if playSound { soundButton.texture = SKTexture(imageNamed: "Settings")} //soundOff
        else {soundButton.texture = SKTexture(imageNamed: "Settings")} //soundOn

        self.addChild(soundButton)
        self.addChild(backButton)
        self.addChild(developerCredits)
        self.addChild(composerCredits)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            if backButton.contains(location) {
                let scene = MenuScene(size: self.size)
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.left, duration: 1))
            } else if soundButton.contains(location) {
                toggleSound()
            } else if developerCredits.contains(location) {
                UIApplication.shared.openURL(URL(string: "http://matthewmohandiss.weebly.com")!)
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
