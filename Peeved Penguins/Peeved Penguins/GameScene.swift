//
//  GameScene.swift
//  Peeved Penguins
//
//  Created by Marshall Cain on 6/23/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Game objects
    var catapultArm: SKSpriteNode!
    
    // Set up scene
    override func didMove(to view: SKView) {
        
        // Set reference to catapultArm
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode
    }
    
    // Called when screen is first touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Make a Penguin
        let penguin = Penguin()
        
        // Add the penguin to this scene
        addChild(penguin)
        
        // Move penguin to the catapult bucket area
        penguin.position.x = catapultArm.position.x + 32
        penguin.position.y = catapultArm.position.y + 50
        
        // Apply impulse to penguin
        let launchImpulse = CGVector(dx: 200, dy: 0)
        penguin.physicsBody?.applyImpulse(launchImpulse)
    }
    
    // Called in each frame
    override func update(_ currentTime: CFTimeInterval) {
        
    }
}
