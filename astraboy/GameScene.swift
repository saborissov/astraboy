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
    var score = 0
    
    var scoreLabel = SKLabelNode()
    var resultLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var gameOverLabel2 = SKLabelNode()
    
    var timer = Timer()
    
    
    enum ColliderType:UInt32 {
        case Astraboy = 1
        case Object = 2
        case Gap = 4
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
        pipe1.zPosition = -1
        
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
        pipe2.zPosition = -1
        
        self.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOfset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Astraboy.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
            
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue{
                print("Зачет одно очко!")
                score += 100
                
                scoreLabel.text = String(score) + "р."
                
                if scoreLabel.text == "1000р." || scoreLabel.text == "2000р."{
                    
                    //                scoreLabel.fontColor = UIColor.purple
                    //                scoreLabel.fontSize = 55
                    scoreLabel.text = "Молодчина!"
                    
                    
                }
                
                
            }
                
                
                
            else{
                self.speed = 0
                gameOver = true
                timer.invalidate()
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontColor = UIColor.purple
                gameOverLabel2.fontName = "Helvetica"
                gameOverLabel2.fontColor = UIColor.purple
                gameOverLabel.fontSize = 40
                gameOverLabel2.fontSize = 20
                gameOverLabel.text = "Конец игры!"
                gameOverLabel2.text = "Нажми для продолжения"
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                gameOverLabel2.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 150)
                self.addChild(gameOverLabel)
                self.addChild(gameOverLabel2)
                
                
            }
            
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setupGame()
        
        
        
    }
    
    func setupGame() {
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(makePipes), userInfo: nil, repeats: true)
        
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
            bg.zPosition = -2
            self.addChild(bg)
            i += 1
            
        }
        
        
        let astraBoyTexture = SKTexture(imageNamed: "astraboy")
        let astraBoyTexture2 = SKTexture(imageNamed: "astraboy1")
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
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 50
        scoreLabel.text = "0р."
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 120)
        
        resultLabel.fontName = "Helvetica"
        resultLabel.fontSize = 30
        resultLabel.text = "Вы заработали"
        resultLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
        self.addChild(resultLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            astraboy.physicsBody!.isDynamic = true
            //Смещение объекта по оси x/y
            astraboy.physicsBody!.velocity = CGVector(dx: 1, dy: -1)
            //Уровень сложности - смещение по оси y
            astraboy.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
            
        } else{
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setupGame()
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
    
    
}
