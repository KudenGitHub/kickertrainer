//
//  KickertrainerViewModel.swift
//  Kickertrainer
//
//  Created by Dennis Kubousek on 26.05.23.
//

import SwiftUI
import AVFoundation

class KickertrainerViewModel: ObservableObject {
    @Published private var model: Kickertrainer = Kickertrainer(numberOfGoalPositions: 5)
    var randomCounter: Int = 0
    var randomCounterToShow: Int = 0
    var useRandomTime: Bool = true
    var showSetupTimer: Bool = false
    var showRandomCounter: Bool = false
    var selectTwice: Bool = false
    private var timer: Timer?
    private var synthesizer = AVSpeechSynthesizer()
    
    
    var goalPositions: Array<GoalPosition> {
        return model.goalPositions 
    }
    
    var counter: Int {
        return model.counter
    }
    
    var setupCounter: Int {
        return model.setupCounter
    }
        
    func toggleGoalPosition(_ goalPosition: GoalPosition) {
        model.toggleGoalPosition(goalPosition)
    }
    
    func toggleSelectedGoalPosition() {
        model.toggleSelectedGoalPosition()
    }
    
    func selectGoalPosition() {
        model.selectGoalPosition()
    }
    
    func deselectGoalPosition() {
        model.deselectGoalPosition()
    }
    
    func resetGoalPositions() {
        model.resetGoalPositions()
    }
    
    func incrementCounter() {
        model.incrementCounter()
    }

    func decrementCounter() {
        model.decrementCounter()
    }
    
    func resetTimer() {
        model.resetTimer()
        useRandomTime = true
    }

    func startSetupTimer() {
        deselectGoalPosition()
        showRandomCounter = false
        showSetupTimer = true
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSetupCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateSetupCounter() {
        if model.setupCounter > 0 {
            model.setupCounter -= 1
        } else if model.setupCounter == 0 {
            showSetupTimer = false
            timer!.invalidate()
            timer = nil;
            model.setupCounter = 3
            startTimer()
        }
    }
    
    func startTimer() {
        if useRandomTime {
            if model.counter >= 2 {
                randomCounter = Int.random(in: 1..<model.counter+1)
            } else if model.counter == 1 {
                randomCounter = 1
            }
        } else {
            randomCounter = model.counter
        }
        randomCounterToShow = randomCounter
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateCounter() {
        //TODO: after countdown show select random goalposition then after 1-2 seconds select another random goalposition. e.g. in startTimer() make randomCounter + 1 and here add another if randomCounter == 2 {selectGoalPosition()...}. Make a variable to have this as a setting in the app (shoot direclty or shoot second hole e.g. var shootDirectly: Bool = true then use randomCounter else randomCounter + 1). Put code below (line 110 - 122) in seperate function so code doesnt repeat for first hole.
        if randomCounter == 3 && selectTwice {
        selectGoalPosition()
        
        toggleSelectedGoalPosition()
        }
        
        if randomCounter > 1 {
            randomCounter -= 1
       
        } else if randomCounter == 1 {
            deselectGoalPosition()
            selectGoalPosition()
            
            let selectedGoalPosition: Int = model.selectedGoalPosition ?? 0
            let selectedGoalPositionName = goalPositions[selectedGoalPosition].name
            let utterance = AVSpeechUtterance(string: selectedGoalPositionName)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.5

            synthesizer.speak(utterance)
            
            usleep(400000)
            
            toggleSelectedGoalPosition()
            
            timer!.invalidate()
            timer = nil;
            showRandomCounter = true
        }
    }
}
