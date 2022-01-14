//
//  Task.swift
//  GoodList
//
//  Created by Javier Cueto on 14/01/22.
//

import Foundation

enum Priority: Int {
    case hight
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
