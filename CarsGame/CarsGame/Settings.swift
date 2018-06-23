//
//  Settings.swift
//  CarsGame
//
//  Created by Florin Nica on 20.05.2018.
//  Copyright © 2018 Florin Nica. All rights reserved.
//

import Foundation
import UIKit

func randomBetween(firstNumber : CGFloat ,  secondNumber : CGFloat) -> CGFloat{
    return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
}

class Settings {
    
    static let sharedInstance = Settings()
    
    private init(){}
    
    var highScore = 0
    
}

