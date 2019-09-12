//  Concentration.swift
//  Concentration
//
//  Created by Сергей Дорошенко on 18/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import Foundation
import UIKit
 
class Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    var score = 0
    
    var flipCount = 0
    
    private lazy var timeOfLastCardTouch = CACurrentMediaTime()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.choosenCard(at: \(index)): chosen index is out of range")
        flipCount += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if the cards matched
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func updateScore() {
        if indexOfOneAndOnlyFaceUpCard == nil {
            var indicesOfFaceUpCards = [Int]()
            for index in cards.indices {
                if cards[index].isFaceUp {
                    indicesOfFaceUpCards += [index]
                }
            }
            if indicesOfFaceUpCards.count == 2 {
                let index1 = indicesOfFaceUpCards[0]
                let index2 = indicesOfFaceUpCards[1]
                if cards[index1].identifier == cards[index2].identifier {
                    if timeIntervalFromLastCardTouch() < 5.0 {
                        score += 3
                    } else {
                        score += 2
                    }
                } else {
                    if  cards[index1].isUsed || cards[index1].isUsed {
                        score -= 1
                        if score < 0 { score = 0 }
                    }
                    cards[index1].isUsed = true
                    if let indexWithTheSameId = findIndexOfCardWithTheSameId(of: index1) {
                        cards[indexWithTheSameId].isUsed = true
                    }
                    cards[index2].isUsed = true
                    if let indexWithTheSameId = findIndexOfCardWithTheSameId(of: index2) {
                        cards[indexWithTheSameId].isUsed = true
                    }
                }
            }
        }
    }
    
    private func findIndexOfCardWithTheSameId(of index: Int) -> Int? {
        for resultIndex in cards.indices {
            if cards[index].identifier == cards[resultIndex].identifier, index != resultIndex {
                return resultIndex
            }
        }
        return nil
    }
    
    private func timeIntervalFromLastCardTouch() -> Double {
        let prevTimeOfLastCardTouch = timeOfLastCardTouch
        timeOfLastCardTouch = CACurrentMediaTime()
        return timeOfLastCardTouch - prevTimeOfLastCardTouch
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): numberOfPairsOfCards isn't more that 0")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
