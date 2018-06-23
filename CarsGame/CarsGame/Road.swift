//
//  Road.swift
//  CarsGame
//
//  Created by Florin Nica on 12.05.2018.
//  Copyright © 2018 Florin Nica. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit



public class Road : SKScene {
    var stopEverything = true
    
    struct ColliderType {
        static let CAR_COLLIDER : UInt32 = 0
    
        static let ITEM_COLLIDER : UInt32 = 1
        static let ITEM_COLLIDER_1 : UInt32 = 2
    }
    
    @objc func createRoadStrip1(){
        let leftRoadStrip =  SKShapeNode(rectOf: CGSize(width: 15, height: 40))
        leftRoadStrip.strokeColor = SKColor.black
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip =  SKShapeNode(rectOf: CGSize(width: 15, height: 40))
        rightRoadStrip.strokeColor = SKColor.black
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
    }
    
    @objc func createRoadStrip2(){
        let leftRoadStrip =  SKShapeNode(rectOf: CGSize(width: 15, height: 40))
        leftRoadStrip.strokeColor = SKColor.black
        leftRoadStrip.fillColor = SKColor.blue
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip =  SKShapeNode(rectOf: CGSize(width: 15, height: 40))
        rightRoadStrip.strokeColor = SKColor.black
        rightRoadStrip.fillColor = SKColor.blue
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
    }
    
    func showRoadStrip1(){
        enumerateChildNodes(withName: "leftRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 45
        } )
        
        enumerateChildNodes(withName: "rightRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 45
        } )
        
        enumerateChildNodes(withName: "tree", using: { (leftCar, stop) in
            let tree = leftCar as! SKSpriteNode
            tree.position.y -= 25
        })
        
        enumerateChildNodes(withName: "pit", using: { (rightCar, stop) in
            let pit = rightCar as! SKSpriteNode
            pit.position.y -= 25
        })
        
        enumerateChildNodes(withName: "coin", using: { (rightCar, stop) in
            let coin = rightCar as! SKSpriteNode
            coin.position.y -= 25
        })
    }
    
    func showRoadStrip2(){
        enumerateChildNodes(withName: "leftRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 60
        } )
        
        enumerateChildNodes(withName: "rightRoadStrip", using: {(roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 60
        } )
        
        enumerateChildNodes(withName: "tree", using: { (leftCar, stop) in
            let tree = leftCar as! SKSpriteNode
            tree.position.y -= 35
        })
        
        enumerateChildNodes(withName: "pit", using: { (rightCar, stop) in
            let pit = rightCar as! SKSpriteNode
            pit.position.y -= 35
        })
        
        enumerateChildNodes(withName: "coin", using: { (rightCar, stop) in
            let coin = rightCar as! SKSpriteNode
            coin.position.y -= 35
        })
    }
    
    func removeItems(){
        for child in children{
            if child.position.y < -self.size.height {
                child.removeFromParent()
            }
        }
    }
    
    @objc func leftTraffic(){
        if !stopEverything{
            let leftTrafficItem : SKSpriteNode!
            let randonNumber = randomBetween(firstNumber: 0, secondNumber: 8)
            switch Int(randonNumber) {
            case 0...2:
                leftTrafficItem = SKSpriteNode(imageNamed: "tree")
                leftTrafficItem.name = "tree"
                break
            case 3...5:
                leftTrafficItem = SKSpriteNode(imageNamed: "coin")
                leftTrafficItem.name = "coin"
                break
            default:
                leftTrafficItem = SKSpriteNode(imageNamed: "pit")
                leftTrafficItem.name = "pit"
            }
            leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
            let randomNum = randomBetween(firstNumber: 0, secondNumber: 1)
            switch Int(randomNum) {
            case 0:
                leftTrafficItem.position.x = -280
                break
            default:
                leftTrafficItem.position.x = -100
            }
            leftTrafficItem.position.y = 700
            leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
            leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
            leftTrafficItem.physicsBody?.collisionBitMask = 0
            leftTrafficItem.physicsBody?.affectedByGravity = false
            addChild(leftTrafficItem)
        }
    }
    
    
    @objc func rightTraffic(){
        if !stopEverything{
            let rightTrafficItem : SKSpriteNode!
            let randonNumber = randomBetween(firstNumber: 0, secondNumber: 8)
    
            switch Int(randonNumber) {
            case 0...2:
                rightTrafficItem = SKSpriteNode(imageNamed: "tree")
                rightTrafficItem.name = "tree"
                break
            case 3...5:
                rightTrafficItem = SKSpriteNode(imageNamed: "coin")
                rightTrafficItem.name = "coin"
                break
            default:
                rightTrafficItem = SKSpriteNode(imageNamed: "pit")
                rightTrafficItem.name = "pit"
            }
            rightTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            rightTrafficItem.zPosition = 10
            let randomNumber2 = Int(arc4random_uniform(2))
            switch Int(randomNumber2) {
            case 0:
                rightTrafficItem.position.x = 280
                break
            default:
                rightTrafficItem.position.x = 100
            }
            rightTrafficItem.position.y = 700
            rightTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: rightTrafficItem.size.height/2)
            rightTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER_1
            rightTrafficItem.physicsBody?.collisionBitMask = 0
            rightTrafficItem.physicsBody?.affectedByGravity = false
            addChild(rightTrafficItem)
        }
    }
    
}
