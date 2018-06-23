//
//  GameScene.swift
//  CarsGame
//
//  Created by Florin Nica on 30.04.2018.
//  Copyright © 2018 Florin Nica. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import CoreMotion

class GameScene: Road, SKPhysicsContactDelegate {
    
    var leftCar  = SKSpriteNode()
    var rightCar = SKSpriteNode()
    
    var canMove = false
    var leftCarToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    var centerPoint : CGFloat!
    
    var score = 0
    var lives = 3
    var out = 0
    
    let leftCarMinimumX : CGFloat = -280
    let leftCarMaximumX : CGFloat = -100
    
    let rightCarMinimumX : CGFloat = 100
    let rightCarMaximumX : CGFloat = 280
    
    var timer : Timer?
    
    var countDown = 1
    
    var gameSettings = Settings.sharedInstance
    var scoreText = SKLabelNode()
    var livesText = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        initializeCars()
        initializeScore()
        initializeLives()
        self.run(SKAction.playSoundFileNamed("music.mp3", waitForCompletion: false))
        physicsWorld.contactDelegate = self
      
        startTimer1()
        
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(randomBetween (firstNumber: 2, secondNumber: 3)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(randomBetween (firstNumber: 2, secondNumber: 3)), target: self, selector: #selector(GameScene.rightTraffic), userInfo: nil, repeats: true)
        
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime) {
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

        if canMove{
            moveLeftCar(leftSide: leftCarToMoveLeft)
            moveRightCar(rightSide: rightCarToMoveRight)
        }
        
        if out == 0{
            showRoadStrip1()
            if score > 20 {
                stopTimer1()
                startTimer2()
                out = 1
            }
        }
        else {
            showRoadStrip2()
        }
        removeItems()
        
    }
    func startTimer1() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(0.25), target: self, selector:
                #selector (createRoadStrip1), userInfo: nil, repeats: true)
        }
    }
    
    func startTimer2() {
        Timer.scheduledTimer(timeInterval: TimeInterval(0.15), target: self, selector:
                #selector (createRoadStrip2), userInfo: nil, repeats: true)
    }
    
    func stopTimer1() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    func initializeCars() {
        leftCar  = self.childNode(withName: "leftCar")  as! SKSpriteNode
        rightCar = self.childNode(withName: "rightCar") as! SKSpriteNode
        centerPoint = self.frame.size.width / self.frame.size.height
        
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        
        rightCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        rightCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER_1
    }
    
    func initializeScore(){
        let scoreBackGround = SKShapeNode(rect:CGRect(x:-self.size.width/2 + 70 ,y:self.size.height/2 - 130 ,width:180,height:80), cornerRadius: 20)
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackGround)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 4
        addChild(scoreText)
    }
    
    func initializeLives(){
        let livesBackGround = SKShapeNode(rect:CGRect(x:self.size.width/2 - 190 ,y:self.size.height/2 - 130 ,width:180,height:80), cornerRadius: 20)
        livesBackGround.zPosition = 4
        livesBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        livesBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(livesBackGround)
        
        livesText.name = "lives"
        livesText.fontName = "AvenirNext-Bold"
        livesText.text = "3❤️"
        livesText.fontColor = SKColor.black
        livesText.position = CGPoint(x: self.size.width/2 - 100, y: self.size.height/2 - 110)
        livesText.fontSize = 50
        livesText.zPosition = 4
        addChild(livesText)
    }
  
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "leftCar" || contact.bodyA.node?.name == "rightCar"{
            if contact.bodyB.node?.name == "coin"{
                score += 5
                contact.bodyB.node!.removeFromParent()
            }
            else if contact.bodyB.node?.name == "pit"{
                contact.bodyB.node!.removeFromParent()
                if (lives > 1){
                    decreaseLives()
                }
                else {
                    explosion(pos: CGPoint(x: 100, y: 100))
                    contact.bodyA.node!.removeFromParent()
                    afterCollision()
                }
            }
            else{
                explosion(pos: CGPoint(x: 100, y: 100))
                contact.bodyA.node!.removeFromParent()
                afterCollision()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if touchLocation.x > centerPoint{
                if rightCarAtLeft{
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                }
                else{
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                }
            }
            else{
                if leftCarAtRight{
                    leftCarAtRight = false
                    leftCarToMoveLeft = true
                }
                else{
                    leftCarAtRight = true
                    leftCarToMoveLeft = false
                }
                
            }
            canMove = true
        }
    }
    
    func moveLeftCar(leftSide:Bool){
        if leftSide{
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarMinimumX{
                leftCar.position.x = leftCarMinimumX
            }
        }
        else{
            leftCar.position.x += 20
            if leftCar.position.x > leftCarMaximumX{
                leftCar.position.x = leftCarMaximumX
            }
        }
    }
    
    func moveRightCar(rightSide:Bool){
        if rightSide{
            rightCar.position.x += 20
            if rightCar.position.x > rightCarMaximumX{
                rightCar.position.x = rightCarMaximumX
            }
        }
        else{
            rightCar.position.x -= 20
            if rightCar.position.x < rightCarMinimumX{
                rightCar.position.x = rightCarMinimumX
            }
        }

    }
    
    @objc func increaseScore(){
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
        }
    }
    
    @objc func decreaseLives(){
        if !stopEverything{
            lives -= 1
            livesText.text = String(lives)+"❤️"
        }
    }
    
    @objc func startCountDown(){
        if countDown>0{
            if countDown < 4{
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countDownLabel.removeFromParent()
                })
            }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
        }
    }
    
    func explosion(pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "Explosion.sks")
        emitterNode?.particlePosition = pos
        emitterNode?.zPosition = 0
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode?.removeFromParent() })
        
    }
    
    func afterCollision(){
        if gameSettings.highScore < score{
            gameSettings.highScore = score
        }
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
    }
}
