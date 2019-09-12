//
//  ViewController.swift
//  Set
//
//  Created by Сергей Дорошенко on 27/07/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

/// This class is a controller of the card game set view.
@IBDesignable
class SetViewController: UIViewController {
    
    /// The card game set model object.
    private var game = Set()

    /// Views of cards that was matched by the model.
    private var matchedCardViews: [PlayingCardView] {
        return gameView.playingCardViews.filter { $0.isMatched == true }
    }
    
    /// A center of a deck view relative to a game view coordinate system.
    private var deckViewCenter: CGPoint {
        return view.convert(deckView.center, to: gameView)
    }
    
    /// A center of a discard pile view relative to a game view coordinate system.
    private var discardPileCenter: CGPoint {
        return view.convert(discardPile.center, to: gameView)
    }
    
    /// The game view outlet responsible for swipe and rotate gestures.
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(touchDeal3Button))
            swipe.direction = .down
            gameView.addGestureRecognizer(swipe)
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateCards))
            gameView.addGestureRecognizer(rotate)
        }
    }

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var cheatButton: UIButton!
    @IBOutlet weak var discardPile: UIButton!
    
    @IBOutlet weak var deckView: UIButton! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(touchDeal3Button))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            deckView.addGestureRecognizer(tap)
        }
    }
    
    /// An object that provides physics-related capabilities and animations for its dynamic items (i. e. for playing cards), and provides the context for those animations.
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    /// An object that confers a behavioral configuration on one or more dynamic items, for their participation in 2D card animation.
    lazy var cardBehavior = CardBehavior(in: animator)
    
    /// An array of card views need to be dealt.
    private var dealCardViews: [PlayingCardView] {
        return gameView.playingCardViews.filter { $0.alpha == 0 }
    }
    
    /// Card views that will be animated.
    private var flyingCardCopies = [PlayingCardView]()
    
    /// Changes all the viewcontroller subviews in accordance with model changes.
    private func updateViewFromModel() {
        updateCardViewsFromModel()
        lastHint = 0
        scoreLabel.text = "Score: \(game.score)"
    }

    /// Updates card views according to model changes.
    private func updateCardViewsFromModel() {
        var newCardViews = [PlayingCardView]()
        
        if gameView.playingCardViews.count - game.visibleCards.count > 0 {
            gameView.removeCardViews(cardViews: matchedCardViews)
        }
        let numberCardViews = gameView.playingCardViews.count
        
        for index in game.visibleCards.indices {
            let card = game.visibleCards[index]
            if  index > (numberCardViews - 1) {
                let cardView = PlayingCardView()
                updateCardView(cardView, for: card)
                addTapGestureRecognizer(for: cardView)
                cardView.alpha = 0
                newCardViews += [cardView]
            } else {
                let cardView = gameView.playingCardViews[index]
                if cardView.alpha < 1, cardView.alpha > 0, game.isSet != true {
                    cardView.alpha = 0
                }
                updateCardView(cardView, for: card)
            }
        }
        gameView.addCardViews(cardViews: newCardViews)
        flyawayAnimation()
        deal3Animation()
    }
    
    /// Animates a fly of matched cards.
    private func flyawayAnimation() {
        // Matched cards animation
        let alreadyFliedCount = matchedCardViews.filter {($0.alpha < 1 && $0.alpha > 0)}.count
        if  game.isSet == true, alreadyFliedCount == 0 {
            
            flyingCardCopies.forEach { tmpCard in
                tmpCard.removeFromSuperview()
            }
            flyingCardCopies = []
            
            matchedCardViews.forEach {cardView in
                cardView.alpha = 0.05
                flyingCardCopies += [cardView.copyCard()]
            }
            
            flyingCardCopies.forEach { tmpCard in
                gameView.addSubview(tmpCard)
                cardBehavior.addItem(tmpCard)
            }
            
            flyingCardCopies[0].addDiscardPile = { [weak self] in
                if let countSets = self?.game.numberOfSets, countSets > 0 {
                    self?.discardPile.alpha = 0
                }}
            
            flyingCardCopies[2].addDiscardPile = {  [weak self] in
                if let countSets = self?.game.numberOfSets, countSets > 0 {
                    self?.discardPile.alpha = 1
                }}
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
                var counter = 1
                for tmpCard in self.flyingCardCopies {
                    self.cardBehavior.removeItem(tmpCard)
                    tmpCard.animateFly(to: self.discardPileCenter, delay: TimeInterval(counter) * 0.25)
                    counter += 1
                }
            }
        }
    }
    
    /// Animates a deal 3 more cards.
    private func deal3Animation() {
        var currentDealCard = 0
        let timeInterval = 0.15  * Double(gameView.grid?.cellCount ?? 0 + 1)
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (_) in
                for cardView in self.dealCardViews {
                    cardView.animateDeal3(
                        from: self.deckViewCenter,
                        delay: TimeInterval(currentDealCard) * 0.25
                    )
                    currentDealCard += 1
                }
        }
    }
    
    /// Adds a tap gesture recognizer for the given playing card view.
    ///
    /// - Parameter cardView: A playing card view for gesture recognizing.
    private func addTapGestureRecognizer(for cardView: PlayingCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }

    /// Responds to a tap gesture.
    ///
    /// - Parameter recognizer: A tap gesture recognizer.
    @objc private func tapCard(recognizedBy recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? PlayingCardView {
                game.chooseCard(at: gameView.playingCardViews.firstIndex(of: cardView)!)
            }
        default:
            break
        }
        updateViewFromModel()
    }
    
    /// Updates the given playing card view according to the given card.
    ///
    /// - Parameters:
    ///   - cardView: A playing card view need to be updated.
    ///   - card: A member of a Card struct need to update view.
    private func updateCardView(_ cardView: PlayingCardView, for card: SetCard) {
        cardView.card = card
        cardView.isSelected = game.cardsSelected.contains(card)
        if let isSet = game.isSet {
            if game.cardsTryMatched.contains(card) {
                cardView.isMatched = isSet
            }
        } else {
            cardView.isMatched = nil
        }
    }

    /// Responds to deal 3 more button touching.
    @objc private func touchDeal3Button() {
        game.deal3()
        updateViewFromModel()
    }
    
    /// The index of the last taken set in the hints array (which contatins all the visible sets at that moment).
    private var lastHint = 0
    
    /// Responds to cheat button touching.
    @IBAction func touchCheatButton() {
        if  game.hints.count > 0 {
            game.hints[lastHint].forEach { gameView.playingCardViews[$0].hint() }
        }
    }

    /// Responds to the new game button touching.
    @IBAction func touchNewGameButton() {
        game = Set()
        gameView.resetCardViews()
        flyingCardCopies.forEach { $0.removeFromSuperview() }
        flyingCardCopies = []
        updateViewFromModel()
    }

    /// Shuffles the cards whenever user rotates the card views.
    ///
    /// - Parameter sender: UITapGestureRecognizer
    @objc func rotateCards(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }

    /// Moves discarded card views into the right position after screen rotation.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flyingCardCopies.forEach { $0.center = discardPileCenter }
    }
}
