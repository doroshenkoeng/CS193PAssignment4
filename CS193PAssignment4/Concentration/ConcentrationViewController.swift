//
//  ViewController.swift
//  Concentration
//
//  Created by Сергей Дорошенко on 16/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit
 
class ConcentrationViewController: UIViewController {
    
    private var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
        
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        guard cardButtons != nil else { return }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            }
        }
        game.updateScore()
        scoreCountLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
    }
    
    @IBAction private func touchNewGameButton(_ sender: UIButton) {
        game.flipCount = 0
        game.score = 0
        scoreCountLabel.text = "Score: \(game.score)"
        flipCountLabel.text = "Flips: \(game.flipCount)"
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        resetCardButtons()
    }
    
    private func resetCardButtons() {
        for cardButton in cardButtons {
            cardButton.setTitle("", for: UIControl.State.normal)
            cardButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? "⌚️📱📲💻⌨️🖥🖨🖱🖲"
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    var emojiChoices = "⌚️📱📲💻⌨️🖥🖨🖱🖲"
    
    private var emoji = [Int: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, !emojiChoices.isEmpty {
            let index = emojiChoices.index(emojiChoices.startIndex, offsetBy: Int.random(in: 0..<emojiChoices.count))
            emoji[card.identifier] = String(emojiChoices.remove(at: index))
        }
        return emoji[card.identifier] ?? "?"
    }
}
