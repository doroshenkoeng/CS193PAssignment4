//
//  Card.swift
//  Set
//
//  Created by Сергей Дорошенко on 29/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import Foundation

/// The struct represents a card in the game set.
struct SetCard {
    var color: Type
    var shape: Type
    var fill: Type
    var numberOfShapes: Type
}

// MARK: - The extension gives an opportunity to use a card dicitionary.
extension SetCard: Hashable {
    private static func == (card1: SetCard, card2: SetCard) -> Bool {
        return card1.color == card2.color && card1.shape == card2.shape &&
               card1.fill == card2.fill && card1.numberOfShapes == card2.numberOfShapes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
        hasher.combine(shape)
        hasher.combine(fill)
        hasher.combine(numberOfShapes)
    }
}
