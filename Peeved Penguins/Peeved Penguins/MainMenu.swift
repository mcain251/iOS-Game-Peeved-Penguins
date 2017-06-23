//
//  MainMenu.swift
//  Peeved Penguins
//
//  Created by Marshall Cain on 6/23/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    // UI
    var playButton: MSButtonNode!
    
    // Setup scene
    override func didMove(to view: SKView) {
        
        // Set reference to play button
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        
        // Play button functionality
        playButton.selectedHandler = {
            self.loadGame()
        }
    }
    
    // Changes the scene to GameScene
    func loadGame() {
        
        // Set reference to SpriteKit view
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        // Creates GameScene
        guard let scene = GameScene(fileNamed: "GameScene") else {
            print ("Could not make GameScene")
            return
        }
        
        // Ensure correct aspect mode
        scene.scaleMode = .aspectFill
        
        // Show debug
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        // Start GameScene
        skView.presentScene(scene)
    }
    
}
