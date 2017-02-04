//
//  GameScene.swift
//  Descent
//
//  Created by Matthew Mohandiss on 3/3/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    var _paused = false
    
    override func didMove(to view: SKView) {
        
        adBannerView?.isHidden = true //just in case
        
        print(interval)
        self.backgroundColor = SKColor.white
        timeDisplay.text = "\(time)"
        timeDisplay.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 30)
        timeDisplay.fontColor = SKColor.black
        timeDisplay.zPosition = 1
        
        pauseButton.anchorPoint = CGPoint(x: 0, y: 1)
        pauseButton.setScale(0.75)
        pauseButton.position = CGPoint(x: 5, y: self.frame.maxY - 5)
        pauseButton.zPosition = 1
        
        redBar.color = SKColor.red
        blueBar.color = SKColor.blue
        greenBar.color = SKColor.green
        yellowBar.color = SKColor.yellow
        
        let bars = [redBar,blueBar,yellowBar,greenBar]
        for bar in bars {
            bar.colorBlendFactor = 1
            bar.alpha = 0.25
            bar.size = CGSize(width: self.frame.width, height: 150)
            bar.anchorPoint = CGPoint.zero
        }
        
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
        
        let actionwait = SKAction.wait(forDuration: 0.01)
        let actionrun = SKAction.run({
            if !self._paused {
            self.time += 0.01
            self.timeDisplay.text = NSString(format: "%.2f", self.time) as String
            }
        })
        
        timeDisplay.run(SKAction.repeatForever(SKAction.sequence([actionwait,actionrun])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if !pauseButton.contains(location) && !_paused{
                var selectedBlock: Block?
                var barsToTest = [SKSpriteNode]()
                self.enumerateChildNodes(withName: "block") {
                    node, stop in
                    if node.contains(location) {
                        selectedBlock = (node as! Block)
                    }
                }
                if selectedBlock != nil {
                    if selectedBlock!.intersects(redBar) {barsToTest.append(redBar); print("red intersects")}
                    if selectedBlock!.intersects(blueBar) {barsToTest.append(blueBar); print("blue intersects")}
                    if selectedBlock!.intersects(greenBar) {barsToTest.append(greenBar); print("green intersects")}
                    if selectedBlock!.intersects(yellowBar) {barsToTest.append(yellowBar); print("yellow intersects")}
                    
                    if !barsToTest.isEmpty {
                        var shouldShrink = true
                        for bar in barsToTest {
                            if bar.color == selectedBlock!.color {
                                shouldShrink = false
                                self.run(SKAction.playSoundFileNamed("Ding.mp3", waitForCompletion: false))
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
            } else if pauseButton.contains(location){
                pause()
            }
        }
    }
    
    func pause() {
        if !_paused {
            self._paused = true
            musicPlayer.pause()
            self.enumerateChildNodes(withName: "block") {
                node, stop in
                node.isPaused = true
            }
        } else {
            musicPlayer.play()
            self._paused = false
            self.enumerateChildNodes(withName: "block") {
                node, stop in
                node.isPaused = false
            }
        }
    }
    
    func spawnBlock() {
        let timerThreshold = 0.6
        
        if !_paused {
        let rand = arc4random_uniform(5)
        var block = Block()
        let speed = CGFloat(50) //CGFloat(40 + time * 2)
        
        switch rand {
        case 0:
            block = Block(color: SKColor.red, speed: speed)
        case 1:
            block = Block(color: SKColor.blue, speed: speed)
        case 2:
            block = Block(color: SKColor.green, speed: speed)
        case 3:
            block = Block(color: SKColor.blue, speed: speed)
        case 4:
            block = Block(color: SKColor.yellow, speed: speed)
        default:
            print("Block color switch exhausted")
            block = Block(color: SKColor.red, speed: speed)
        }
        let randx = CGFloat(arc4random_uniform(UInt32(self.size.width - block.size.width)))
        block.position = CGPoint(x: randx, y: CGFloat( self.size.height))
        self.addChild(block)
        }
        if 1.75 - (time/20) > timerThreshold {
        self.run(SKAction.wait(forDuration: 1.75 - (time/20)), completion: {self.spawnBlock()})
        } else {
            self.run(SKAction.wait(forDuration: timerThreshold), completion: {self.spawnBlock()})
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.enumerateChildNodes(withName: "block") {
            node, stop in
            let block = node as! Block
            if block.position.y < -block.size.height {
                self.enumerateChildNodes(withName: "block") {
                    node, stop in
                    node.removeFromParent()
                }
                self.endGame()
            }
        }
    }
    
    func UpdateBarPositions() {
        greenBar.position = CGPoint(x: self.frame.minX, y: yellowBar.size.height)
        blueBar.position = CGPoint(x: self.frame.minX, y: yellowBar.size.height + greenBar.size.height)
        redBar.position = CGPoint(x: self.frame.minX, y: yellowBar.size.height + greenBar.size.height + blueBar.size.height)
    }
    
    func endGame() {
        self._paused = true
        
        let scene = MenuScene(size: self.size)
        scene.userData = NSMutableDictionary()
        scene.userData!.setObject(time, forKey: "Time" as NSCopying)
        //fadeMusic(true)
        musicPlayer.stop()
        let currentHigh = UserDefaults.standard.object(forKey: "score") as? Double
        if currentHigh != nil {
            if time > currentHigh {
                UserDefaults.standard.set(time, forKey:"score")
                UserDefaults.standard.synchronize()
                
            }
        }
        
        self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.down, duration: 1))
    }
    
    func playBackgroundMusic() {
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Void Rush.aif", withExtension: nil)!)
        } catch let error as NSError {
            print(error)
            musicPlayer = nil
        }
        
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.5
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        //fadeMusic(false)
    }
    
    func fadeMusic(_ fadeToSilence: Bool) {
        if fadeToSilence {
            while musicPlayer.volume > 0.1 {
                self.run(SKAction.wait(forDuration: 0.1), completion: {musicPlayer.volume -= 0.1})
            }
            musicPlayer.stop()
        } else {
            while musicPlayer.volume < 0.5 {
                self.run(SKAction.wait(forDuration: 0.1), completion: {musicPlayer.volume += 0.1})
            }
        }
    }
}
