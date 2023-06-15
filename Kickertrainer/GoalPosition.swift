//
//  GoalPosition.swift
//  Kickertrainer
//
//  Created by Dennis Kubousek on 26.05.23.
//

import Foundation

struct GoalPosition: Identifiable, Hashable {
    var isActive: Bool = true
    var isSelected: Bool = false
    private(set) var name: String
    var id: Int
    
}
