//
//  Kickertrainer.swift
//  Kickertrainer
//
//  Created by Dennis Kubousek on 26.05.23.
//

import Foundation

struct Kickertrainer {
    var goalPositions: Array<GoalPosition>
    var selectedGoalPosition: Int?
    var counter: Int
    var setupCounter: Int
    
    init(numberOfGoalPositions: Int) {
        goalPositions = Array<GoalPosition>()
        for goalPosition in 1..<numberOfGoalPositions+1 {
            goalPositions.append(GoalPosition(name: String(goalPosition), id: goalPosition ))
        }
        counter = 15
        setupCounter = 3
    }
    
    mutating func toggleGoalPosition(_ goalPosition: GoalPosition ) {
        let chosenIndex = index(of: goalPosition)
        goalPositions[chosenIndex!].isActive.toggle()
    }
    
    mutating func selectGoalPosition() {
        var activeGoalPositionsCount = Array<Int>()
        
        for goalPosition in goalPositions {
            if goalPosition.isActive == true {
                activeGoalPositionsCount.append(index(of: goalPosition)!)
            }
        }
        if activeGoalPositionsCount.count > 0 {
            selectedGoalPosition = activeGoalPositionsCount.randomElement()!
        }
    }
    
    mutating func toggleSelectedGoalPosition() {
        goalPositions[selectedGoalPosition!].isSelected.toggle()
    }
    
    mutating func deselectGoalPosition() {
        if selectedGoalPosition != nil {
            goalPositions[selectedGoalPosition!].isSelected = false
        }
    }
    
    mutating func resetGoalPositions() {
        deselectGoalPosition()
        for goalPosition in goalPositions {
            let chosenIndex = index(of: goalPosition)
            goalPositions[chosenIndex!].isActive = true
        }
    }
    
    mutating func resetTimer() {
        counter = 15
    }
    
    mutating func resetSetupTimer() {
        setupCounter = 3
    }
    
    mutating func incrementCounter() {
        if counter < 15 {
            counter += 1
        }
    }

    mutating func decrementCounter() {
        if counter > 1 {
            counter -= 1
        }
    }
    
    func index(of: GoalPosition) -> Int? {
        for index in 0..<goalPositions.count {
            if goalPositions[index].id == of.id {
                return index
            }
        }
        return nil
    }
}
