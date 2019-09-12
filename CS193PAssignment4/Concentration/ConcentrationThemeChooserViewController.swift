//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Сергей Дорошенко on 11/09/2019.
//  Copyright © 2019 Сергей Дорошенко. All rights reserved.
//
 
import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    
    let themes = [
        "Sports" : "⚽️🏀🏈⚾️🥎🏐🏉🏓⛸",
        "Faces" : "😀😃😄😆😅😂🤣☺️😇",
        "Animals" : "🐅🦝🦙🦔🦒🦓🦘🐌🐄"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                }
            }
        }
    }
}
