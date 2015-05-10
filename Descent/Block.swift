//
//  Block.swift
//  ColorColorFunTime
//
//  Created by Matthew Mohandiss on 1/31/15.
//  Copyright (c) 2015 Matthew Mohandiss. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    convenience init(color: SKColor, speed: CGFloat) {
        //let image = SKTexture(imageNamed: "Drop")
        let image = SKTexture(imageNamed: "Block")
        self.init(texture: image, color: color, size: image.size()) //45,45
        self.runAction(SKAction.repeatActionForever(SKAction.moveByX(0, y: -speed, duration: 0.25)))
        self.name = "block"
        self.anchorPoint = CGPointMake(0, 0)
        self.colorBlendFactor = 1
        //self.setScale(0.3)
        self.setScale(0.4)
    }
}
