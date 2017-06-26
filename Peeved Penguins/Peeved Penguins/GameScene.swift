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
    
    // Constants
    let force: CGFloat = 350
    
    // Game objects
    var catapultArm: SKSpriteNode!
    var catapult: SKSpriteNode!
    
    // Helper nodes
    var cantileverNode: SKSpriteNode!
    var touchNode: SKSpriteNode!
    
    // Joints
    var touchJoint: SKPhysicsJointSpring?
    var penguinJoint: SKPhysicsJointPin?
    
    // Camera objects
    var cameraNode: SKCameraNode!
    var cameraTarget: SKSpriteNode?
    
    // Buttons
    var restartButton: MSButtonNode!
    
    // Set up scene
    override func didMove(to view: SKView) {
        
        // Set reference to catapult parts
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode
        catapult = childNode(withName: "catapult") as! SKSpriteNode
        cantileverNode = childNode(withName: "cantileverNode") as! SKSpriteNode
        touchNode = childNode(withName: "touchNode") as! SKSpriteNode
        
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
        
        // Set up catapult physics
        setupCatapult()
    }
    
    // Sets up the catapult joints
    func setupCatapult() {
        
        // Pin joint
        var pinLocation = catapultArm.position
        pinLocation.x += -10
        pinLocation.y += -70
        let catapultJoint = SKPhysicsJointPin.joint(
            withBodyA:catapult.physicsBody!,
            bodyB: catapultArm.physicsBody!,
            anchor: pinLocation)
        physicsWorld.add(catapultJoint)
        
        // Spring joint
        var anchorAPosition = catapultArm.position
        anchorAPosition.x += 0
        anchorAPosition.y += 50
        let catapultSpringJoint = SKPhysicsJointSpring.joint(withBodyA: catapultArm.physicsBody!, bodyB: cantileverNode.physicsBody!, anchorA: anchorAPosition, anchorB: cantileverNode.position)
        physicsWorld.add(catapultSpringJoint)
        catapultSpringJoint.frequency = 6
        catapultSpringJoint.damping = 0.5
    }
    
    // Called when screen is first touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Get the first touch
        let touch = touches.first!
        
        // Find the location of that touch in this view
        let location = touch.location(in: self)
        
        // Find the node at that location
        let nodeAtPoint = atPoint(location)
        
        // Attaches the touchNode if the catapultArm is touched
        if nodeAtPoint.name == "catapultArm" {
            touchNode.position = location
            touchJoint = SKPhysicsJointSpring.joint(withBodyA: touchNode.physicsBody!, bodyB: catapultArm.physicsBody!, anchorA: location, anchorB: location)
            physicsWorld.add(touchJoint!)
        }
        
        // Initializes a penguin
        let penguin = Penguin()
        addChild(penguin)
        penguin.position.x += catapultArm.position.x + 20
        penguin.position.y += catapultArm.position.y + 50
        
        // Pins the penguin to the catapult bowl
        penguin.physicsBody?.usesPreciseCollisionDetection = true
        penguinJoint = SKPhysicsJointPin.joint(withBodyA: catapultArm.physicsBody!, bodyB: penguin.physicsBody!, anchor: penguin.position)
        physicsWorld.add(penguinJoint!)
        
        // Sets camera to follow penguin
        cameraTarget = penguin
    }
    
    // Called during touch motion
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        touchNode.position = location
    }
    
    // Called when touch is released
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchJoint = touchJoint {
            physicsWorld.remove(touchJoint)
        }
        
        if let penguinJoint = penguinJoint {
            physicsWorld.remove(penguinJoint)
            
            // Check if there is a penguin assigned to the cameraTarget
            guard let penguin = cameraTarget else {
                return
            }
            
            // Generate a vector and a force based on the angle of the arm.
            let r = catapultArm.zRotation
            let dx = cos(r) * force
            let dy = sin(r) * force
            
            // Apply an impulse at the vector.
            let v = CGVector(dx: dx, dy: dy)
            penguin.physicsBody?.applyImpulse(v)
        }
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
