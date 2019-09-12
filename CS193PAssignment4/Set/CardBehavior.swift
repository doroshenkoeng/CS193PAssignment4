//
//  CardBehavior.swift
//  GraphicalSet
//
//  Created by Сергей Дорошенко on 08/09/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import UIKit

/// A class that confers a behavioral configuration on one or more dynamic items, for their participation in 2D card animation.
class CardBehavior: UIDynamicBehavior {
    /// An object that confers to a specified array of dynamic items the ability to engage in collisions with each other and with the behavior’s specified boundaries.
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    /// A base dynamic animation configuration for one or more dynamic items.
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 0.8
        behavior.resistance = 0.2
        return behavior
    }()
    
    /// A behavior that applies a continuous or instantaneous force to one or more dynamic items, causing those items to change position accordingly.
    ///
    /// - Parameter item: A dynamic item need to be pushed.
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = 0.75 * CGFloat.pi - CGFloat(Double.random(in: 0...(2 * Double.pi)))
        push.magnitude = CGFloat(10.0) + CGFloat(Double.random(in: 0...2.0))
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    /// Appends a dynamic item to animation process.
    ///
    /// - Parameter item: A dynamic item need to be added.
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    /// Removes a dynamic item from animation process.
    ///
    /// - Parameter item: A dynamic item need to be removed.
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
