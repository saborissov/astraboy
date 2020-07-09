//
//  GameScene.swift
//  astraboy
//
//  Created by 17586317 on 06.07.2020.
//  Copyright © 2020 Борисов Сергей Александрович. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var astraboy = SKSpriteNode()
    var bg = SKSpriteNode()
    
    enum ColliderType:UInt32 {
        case Astraboy = 1
        case Object = 2
    }
    
    var gameOver = false
    
    
    @objc func makePipes() {
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval (self.frame.width / 100))
        let astraBoyTexture = SKTexture(imageNamed: "astraboy")
        //расстояние между труб
        let gapHight = astraBoyTexture.size().height * 3
        
        let movementMount = arc4random() % UInt32(self.frame.height / 2)
        
        let pipeOfset = CGFloat(movementMount) - self.frame.height / 4
        
        let pipeTexture = SKTexture(imageNamed: "pipe1")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHight / 2 + pipeOfset)
        pipe1.run(movePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe1)
        
        let pipe2Texture = SKTexture(imageNamed: "pipe2")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipe2Texture.size().height / 2 - gapHight/2 + pipeOfset)
        
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       
        print("Есть контакт")
        self.speed = 0
        gameOver = true
        print("Конец игры")
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(makePipes), userInfo: nil, repeats: true)
        
        let bgTexture = SKTexture(imageNamed: "bg")
        let moveBGAnimation = SKAction.move(by: CGVector (dx: -bgTexture.size().width, dy: 0 ), duration: 5)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0 ), duration: 0)
        
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation,shiftBGAnimation]))
        
        var i:CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            bg.run(moveBGForever)
            bg.zPosition = -1
            self.addChild(bg)
            i += 1
            
        }
        
        
        let astraBoyTexture = SKTexture(imageNamed: "astraboy")
        let astraBoyTexture2 = SKTexture(imageNamed: "astraboy")
        let animation = SKAction.animate(with: [astraBoyTexture,astraBoyTexture2], timePerFrame: 0.1)
        let makeAstraboyFly = SKAction.repeatForever(animation)
        
        astraboy = SKSpriteNode(texture: astraBoyTexture)
        astraboy.position = CGPoint(x: -50, y: self.frame.midY)
        
        astraboy.run(makeAstraboyFly)
        
      
        astraboy.physicsBody = SKPhysicsBody(circleOfRadius: astraBoyTexture.size().height / 2)
        astraboy.physicsBody!.isDynamic = false
        
        astraboy.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        astraboy.physicsBody!.categoryBitMask = ColliderType.Astraboy.rawValue
        astraboy.physicsBody!.collisionBitMask = ColliderType.Astraboy.rawValue
        
        
        self.addChild(astraboy)
        
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            
            astraboy.physicsBody!.isDynamic = true
//        let astraBoyTexture = SKTexture(imageNamed: "astraboy")
//        astraboy.physicsBody = SKPhysicsBody(circleOfRadius: astraBoyTexture.size().height / 2)
        //Смещение объекта по оси x/y
            astraboy.physicsBody!.velocity = CGVector(dx: 1, dy: -1)
            astraboy.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 60))
            
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    
}
