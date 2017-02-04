//
//  LeaderBoardsScene.swift
//  Descent
//
//  Created by Matthew Mohandiss on 8/30/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit
import GameKit

class LeaderBoardsScene: SKScene {
    
    var title = SKLabelNode()
    enum board { case allTime, friends }
    var boardType = board.allTime
    var backButton = SKLabelNode(text: "◀︎ Back")
    
    override func didMove(to view: SKView) {
        backButton.fontColor = SKColor.black
        backButton.position = CGPoint(x: self.frame.minX + 55, y: self.frame.maxY - ((adBannerView?.frame.height)! + 30))
    
        let devider = SKSpriteNode(imageNamed: "Devider")
        devider.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        title.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (title.frame.height + (adBannerView?.frame.height)! + 60))
        title.fontColor = SKColor.black
        loadLeaderboard()
        
        self.addChild(devider)
        self.addChild(title)
        self.addChild(backButton)
    }
    
    func loadLeaderboard() {
        switch boardType {
        case .allTime:
        self.title.text = "All Time"
        case .friends:
        self.title.text = "Friends"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if backButton.contains(location) {
                let scene = MenuScene(size: self.size)
                //adBannerView.hidden = true
                //println("Removed ad")
                self.view?.presentScene(scene, transition: SKTransition.push(with: SKTransitionDirection.right, duration: 1))
            }
        }
    }
    
}

class BoardEntry: SKSpriteNode {
    var playerName = "Player"
    var score = "Score"
    
    convenience init() {
        let texture = SKTexture(imageNamed: "")
        //self.init(texture: texture, color: SKColor.whiteColor(), size: CGSizeMake(10, 200))
        self.init()
        self.texture = texture
        self.color = SKColor.white
        self.size = CGSize(width: 10, height: 200)
        self.size = CGSize(width: 10, height: 200)
        self.position = CGPoint(x: 0, y: -self.size.height)
    }
    
    func build() {
        self.size.width = self.parent!.scene!.size.width
        //work here
    }
    
//    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
//        super.init(texture: texture, color: color, size: size)
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
