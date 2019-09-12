//
//  GameView.swift
//  GraphicalSet
//
//  Created by Сергей Дорошенко on 18/08/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

@IBDesignable

/// This view contains all the playing card views.
class GameView: UIView {
    
    /// Contains all the playing card views.
    var playingCardViews = [PlayingCardView]() {
        willSet {
            removeSubviews()
        }
        didSet {
            addSubviews()
        }
    }
    
    /// Deletes all the playing card views from the game view.
    private func removeSubviews() {
        for cardView in playingCardViews { cardView.removeFromSuperview() }
    }
    
    /// Appends all the playing card views to the game view.
    private func addSubviews() {
        for cardView in playingCardViews { addSubview(cardView) }
    }
    
    var grid: Grid?
    
    /// Lays out playing card views.
    override func layoutSubviews() {
        super.layoutSubviews()
        grid = Grid(layout: Grid.Layout.aspectRatio(Constants.SizeRatio.cellAspectRatio), frame: bounds)
        grid?.cellCount = playingCardViews.count
        for index in playingCardViews.indices {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: Double(index) * 0.1, options: .curveEaseInOut, animations: {
                self.playingCardViews[index].frame = self.grid?[index]?.insetBy(dx: Constants.SizeRatio.horizonalSpacing, dy: Constants.SizeRatio.verticalSpacing) ?? CGRect.zero
            })
            
        }
    }
    
    /// Appends the given playing card views to a game view.
    ///
    /// - Parameter cardViews: An array of playing cards that will be added to a game view.
    func addCardViews(cardViews: [PlayingCardView]) {
        cardViews.forEach { cardView in addSubview(cardView); playingCardViews += [cardView]}
        layoutIfNeeded()
    }
    
    /// Removes the given playing card views from a game view.
    ///
    /// - Parameter cardViews: An array of playing cards that will be removed from a game view.
    func removeCardViews(cardViews: [PlayingCardView]) {
        cardViews.forEach { cardView in cardView.removeFromSuperview(); playingCardViews.remove(elements: [cardView])}
        layoutIfNeeded()
    }
    
    /// Removes all the playing card views from a game view.
    func resetCardViews() {
        playingCardViews.forEach { cardView in cardView.removeFromSuperview()}
        playingCardViews = []
        layoutIfNeeded()
    }
}
