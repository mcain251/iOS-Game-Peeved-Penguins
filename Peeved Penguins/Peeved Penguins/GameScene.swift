//
//  GameScene.swift
//  Peeved Penguins
//
//  Created by Marshall Cain on 6/23/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

// Clamp function
func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}

class GameScene: SKScene {
    
    // Game objects
    var catapultArm: SKSpriteNode!
    
    // Camera objects
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    
    // Buttons
    var restartButton: MSButtonNode!
    
    // Set up scene
    override func didMove(to view: SKView) {
        
        // Set reference to catapultArm
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode
        
        // Set reference to cameraNode and make it the camera
        cameraNode = childNode(withName: "cameraNode") as! SKCameraNode
        camera = cameraNode
        
        // Set reference to restart button
        restartButton = childNode(withName: "//restartButton") as! MSButtonNode
        
        restartButton.selectedHandler = {
            // Creates GameScene
            guard let scene = GameScene.level(1) else {
                print ("Could not load GameScene level 1")
                return
            }
            
            // Ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            // Start GameScene
            view.presentScene(scene)
        }
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
        let launchImpulse = CGVector(dx: 400, dy: 0)
        penguin.physicsBody?.applyImpulse(launchImpulse)
        
        // Set camera to follow penguin
        cameraTarget = penguin
    }
    
    // Called in each frame
    override func update(_ currentTime: CFTimeInterval) {
        
        // Follows penguin
        moveCamera()
    }
    
    // Returns a specific level
    class func level(_ levelNumber: Int) -> GameScene? {
        guard let scene = GameScene(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFill
        return scene
    }
    
    // Tracks the cameraTarget with the camera
    func moveCamera() {
        guard let cameraTarget = cameraTarget else {
            return
        }
        let targetX = cameraTarget.position.x
        let x = clamp(value: targetX, lower: 0, upper: 392)
        cameraNode.position.x = x
    }
}
