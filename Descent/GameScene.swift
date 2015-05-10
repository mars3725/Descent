//
//  GameScene.swift
//  Descent
//
//  Created by Matthew Mohandiss on 3/3/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit
import AVFoundation

var musicPlayer: AVAudioPlayer!

class GameScene: SKScene {
    var time = 0.0
    var interval: Float {
        return 10 * powf(0.95, Float(time + 5.0))
    }
    
    let redBar = SKSpriteNode()
    let blueBar = SKSpriteNode()
    let greenBar = SKSpriteNode()
    let yellowBar = SKSpriteNode()
    let timeDisplay = SKLabelNode()
    let pauseButton = SKSpriteNode(imageNamed: "Pause")
    
    override func didMoveToView(view: SKView) {
        
        println(interval)
        self.backgroundColor = SKColor.whiteColor()
        timeDisplay.text = "\(time)"
        timeDisplay.position = CGPointMake(self.frame.midX, self.frame.maxY - 30)
        timeDisplay.fontColor = SKColor.blackColor()
        
        pauseButton.anchorPoint = CGPointMake(0, 1)
        pauseButton.position = CGPointMake(5, self.frame.maxY - 5)
        
        redBar.color = SKColor.redColor()
        redBar.colorBlendFactor = 1
        redBar.alpha = 0.25
        redBar.size = CGSizeMake(self.frame.width, 150)
        redBar.anchorPoint = CGPointZero
        blueBar.color = SKColor.blueColor()
        blueBar.colorBlendFactor = 1
        blueBar.alpha = 0.25
        blueBar.size = CGSizeMake(self.frame.width, 150)
        blueBar.anchorPoint = CGPointZero
        greenBar.color = SKColor.greenColor()
        greenBar.colorBlendFactor = 1
        greenBar.alpha = 0.25
        greenBar.size = CGSizeMake(self.frame.width, 150)
        greenBar.anchorPoint = CGPointZero
        yellowBar.color = SKColor.yellowColor()
        yellowBar.colorBlendFactor = 1
        yellowBar.alpha = 0.25
        yellowBar.size = CGSizeMake(self.frame.width, 150)
        yellowBar.anchorPoint = CGPointZero
        
        self.addChild(timeDisplay)
        self.addChild(pauseButton)
        self.addChild(redBar)
        self.addChild(blueBar)
        self.addChild(greenBar)
        self.addChild(yellowBar)
        
        if playSound {
            playBackgroundMusic()
        }
        UpdateBarPositions()
        spawnBlock()
        
        var actionwait = SKAction.waitForDuration(0.1)
        var actionrun = SKAction.runBlock({
            self.time += 0.1
            self.timeDisplay.text = NSString(format: "%.1f", self.time) as String
        })
        
        timeDisplay.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if !pauseButton.containsPoint(location) {
                var selectedBlock = Block?()
                var barsToTest = [SKSpriteNode]()
                self.enumerateChildNodesWithName("block") {
                    node, stop in
                    if node.containsPoint(location) {
                        selectedBlock = (node as! Block)
                    }
                }
                if selectedBlock != nil {
                    if selectedBlock!.intersectsNode(redBar) {barsToTest.append(redBar); println("red intersects")}
                    if selectedBlock!.intersectsNode(blueBar) {barsToTest.append(blueBar); println("blue intersects")}
                    if selectedBlock!.intersectsNode(greenBar) {barsToTest.append(greenBar); println("green intersects")}
                    if selectedBlock!.intersectsNode(yellowBar) {barsToTest.append(yellowBar); println("yellow intersects")}
                    
                    if !barsToTest.isEmpty {
                        var shouldShrink = true
                        for bar in barsToTest {
                            if bar.color == selectedBlock!.color {
                                shouldShrink = false
                            }
                            selectedBlock?.removeFromParent()
                            if shouldShrink {
                                for bar in barsToTest {
                                    bar.size.height *= (2/3)
                                    UpdateBarPositions()
                                }
                            }
                        }
                    }
                }
            } else if !paused {
                self.paused = true
                musicPlayer.pause()
            } else {
                musicPlayer.play()
                self.paused = false
            }
        }
    }
    
    func spawnBlock() {
        let rand = arc4random_uniform(5)
        var block = Block()
        let speed = CGFloat(50) //CGFloat(40 + time * 2)
        switch rand {
        case 0:
            block = Block(color: SKColor.redColor(), speed: speed)
        case 1:
            block = Block(color: SKColor.blueColor(), speed: speed)
        case 2:
            block = Block(color: SKColor.greenColor(), speed: speed)
        case 3:
            block = Block(color: SKColor.blueColor(), speed: speed)
        case 4:
            block = Block(color: SKColor.yellowColor(), speed: speed)
        default:
            println("Block color switch exhausted")
            block = Block(color: SKColor.redColor(), speed: speed)
        }
        let randx = CGFloat(arc4random_uniform(UInt32(self.size.width - block.size.width)))
        block.position = CGPointMake(randx, CGFloat( self.size.height))
        self.addChild(block)
        self.runAction(SKAction.waitForDuration(1.75 - (time/20)), completion: {self.spawnBlock()})
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.enumerateChildNodesWithName("block") {
            node, stop in
            let block = node as! Block
            if block.position.y < -block.size.height {
                self.enumerateChildNodesWithName("block") {
                    node, stop in
                    node.removeFromParent()
                }
                self.endGame()
            }
        }
    }
    
    func UpdateBarPositions() {
        greenBar.position = CGPointMake(self.frame.minX, yellowBar.size.height)
        blueBar.position = CGPointMake(self.frame.minX, yellowBar.size.height + greenBar.size.height)
        redBar.position = CGPointMake(self.frame.minX, yellowBar.size.height + greenBar.size.height + blueBar.size.height)
    }
    
    func endGame() {
        self.paused = true
        
        let scene = MenuScene(size: self.size)
        scene.userData = NSMutableDictionary()
        scene.userData!.setObject(time, forKey: "Time")
        //fadeMusic(true)
        musicPlayer.stop()
        let currentHigh = NSUserDefaults.standardUserDefaults().objectForKey("score") as? Double
        if currentHigh != nil {
            if time > currentHigh {
                NSUserDefaults.standardUserDefaults().setObject(time, forKey:"score")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        
        self.view?.presentScene(scene, transition: SKTransition.pushWithDirection(SKTransitionDirection.Down, duration: 1))
    }
    
    func playBackgroundMusic() {
        
        var error: NSError? = nil
        musicPlayer = AVAudioPlayer(contentsOfURL: NSBundle.mainBundle().URLForResource(
            "Void Rush.aif", withExtension: nil), error: &error)
        
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.5
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        //fadeMusic(false)
    }
    
    func fadeMusic(fadeToSilence: Bool) {
        if fadeToSilence {
            while musicPlayer.volume > 0.1 {
                self.runAction(SKAction.waitForDuration(0.1), completion: {musicPlayer.volume -= 0.1})
            }
            musicPlayer.stop()
        } else {
            while musicPlayer.volume < 0.5 {
                self.runAction(SKAction.waitForDuration(0.1), completion: {musicPlayer.volume += 0.1})
            }
        }
    }
}