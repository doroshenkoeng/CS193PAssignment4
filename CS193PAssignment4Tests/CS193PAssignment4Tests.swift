//
//  CS193PAssignment4Tests.swift
//  CS193PAssignment4Tests
//
//  Created by Сергей Дорошенко on 12/09/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//

import XCTest
@testable import CS193PAssignment4

class CS193PAssignment4Tests: XCTestCase {

    var game: Set!
    
    override func setUp() {
        super.setUp()
        game = Set()
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
    
    func testIsSet() {
        // given
        var cardsToTest = [SetCard]()
        cardsToTest += [SetCard(color: .type1, shape: .type1, fill: .type1, numberOfShapes: .type1)]
        cardsToTest += [SetCard(color: .type2, shape: .type2, fill: .type2, numberOfShapes: .type2)]
        cardsToTest += [SetCard(color: .type3, shape: .type3, fill: .type3, numberOfShapes: .type3)]
        // where
        let result  = game.isSet(cardsToTest)
        // then
        XCTAssertTrue(result)
    }
    
    func testChooseCard() {
        // given
        var game = Set()
        // where
        if !game.hints.isEmpty {
            for hintCardIndex in game.hints[0] {
                game.chooseCard(at: hintCardIndex)
            }
            XCTAssertTrue(game.cardsSelected.isEmpty)
            XCTAssertTrue(game.cardsTryMatched.count == 3)
            XCTAssertTrue(game.isSet == true)
        }
        //        let card = game.visibleCards.first!
        //        game.chooseCard(at: 0)
        //        // then
        //        XCTAssertTrue(game.cardsSelected.contains(card))
    }
    
    func testDeal3() {
        // given
        let numberOfVisibleCardsBeforeDeal3 = game.visibleCards.count
        // where
        game.deal3()
        let difference = game.visibleCards.count - numberOfVisibleCardsBeforeDeal3
        let result = difference == 3 || difference == 0
        // then
        XCTAssertTrue(result)
    }
    
    func testCard() {
        // given
        let card1 = SetCard(color: .type1, shape: .type1, fill: .type1, numberOfShapes: .type1)
        let card2 = SetCard(color: .type1, shape: .type1, fill: .type1, numberOfShapes: .type1)
        // where
        let result = card1 == card2
        //then
        XCTAssertTrue(result)
    }
    
    func testIntOutOfArrayExtension() {
        // given
        var array = [Int]()
        // where
        let anElement = 1
        array.inOut(element: anElement)
        // then
        XCTAssertTrue(array.contains(anElement))
        array.inOut(element: anElement)
        XCTAssertFalse(array.contains(anElement))
    }
    
    func testRemoveOfArrayExtension() {
        // given
        var array1 = [1, 3, 4, 5]
        let array2 = [3, 4, 5]
        // where
        array1.remove(elements: array2)
        // then
        XCTAssertTrue(array1.elementsEqual([1]))
    }
    
    func testReplaceOfArrayExtension() {
        // given
        var array1 = [1, 2, 4]
        let array2 = [2, 4]
        let array3 = [5, 7]
        // where
        array1.replace(elements: array2, with: array3)
        // then
        XCTAssertTrue(array1.elementsEqual([1, 5, 7]))
    }
    
    func testIndicesOfArrayExtension() {
        // given
        let array1 = [1, 2, 3, 8, 9]
        let array2 = [8, 9]
        // where
        let resultArrayOfIndices = array1.indices(of: array2)
        // then
        XCTAssertTrue(resultArrayOfIndices.elementsEqual([3, 4]))
    }
    func testHint() {
        // given
        let game = Set()
        for hint in game.hints {
            var testCards = [SetCard]()
            hint.forEach { testCards += [game.visibleCards[$0]] }
            // where
            let result = game.isSet(testCards)
            // then
            XCTAssertTrue(result)
        }
    }
}
