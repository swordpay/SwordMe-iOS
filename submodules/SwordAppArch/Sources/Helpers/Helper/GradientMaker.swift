//
//  GradientMaker.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.02.23.
//

import UIKit

final class GradientMaker {
    private static let colors = ThemeProvider.currentTheme.colors
    
    static var blueGradient: [CGColor] {
        return [ colors.gradientDarkBlue.cgColor,
                 colors.gradientLightBlue.cgColor ]
    }
    
    static var purpleGradient: [CGColor] {
        return [ colors.gradientDarkPink.cgColor,
                 colors.gradientPurple.cgColor ]
    }
    
    static var greenGradient: [CGColor] {
        return [ colors.gradientLightGreen.cgColor,
                 colors.gradientBorderLightBlue.cgColor,
                 colors.gradientPurple.cgColor ]
    }
    
    static var orangeGradient: [CGColor] {
        return [ colors.gradientOrange.cgColor,
                 colors.gradientDarkPink.cgColor,
                 colors.gradientLightPink.cgColor ]
    }
    
    static var card1: [CGColor] {
        return [ colors.card1StartGradient.cgColor,
                 colors.card1EndGradient.cgColor ]
    }
    
    static var card2: [CGColor] {
        return [ colors.card1StartGradient.cgColor,
                 colors.card2EndGradient.cgColor ]
    }

    static var card3: [CGColor] {
        return [ colors.card1StartGradient.cgColor,
                 colors.card3EndGradient.cgColor ]
    }
    
    static var card4: [CGColor] {
        return [ colors.card4StartGradient.cgColor,
                 colors.card4EndGradient.cgColor ]
    }
    
    static var card5: [CGColor] {
        return [ colors.card5StartGradient.cgColor,
                 colors.card5EndGradient.cgColor ]
    }
    
    static var card6: [CGColor] {
        return [ colors.card6StartGradient.cgColor,
                 colors.card6EndGradient.cgColor ]
    }
    
    static var card7: [CGColor] {
        return [ colors.card7StartGradient.cgColor,
                 colors.card7EndGradient.cgColor ]
    }
    
    static var card8: [CGColor] {
        return [ colors.card8StartGradient.cgColor,
                 colors.card8EndGradient.cgColor ]
    }

    static var card9: [CGColor] {
        return [ colors.card9StartGradient.cgColor,
                 colors.card8EndGradient.cgColor ]
    }

    static var card10: [CGColor] {
        return [ colors.card10StartGradient.cgColor,
                 colors.card10EndGradient.cgColor ]
    }


    static var allGradients: [[CGColor]] {
        return [ card1, card2, card3, card4, card5, card6, card7, card8, card9, card10 ]
    }
    
    static var randomGradient: [CGColor] {
        return allGradients.randomElement() ?? blueGradient
    }
    
    static func gradient(for orderNumber: Int) -> [CGColor] {
        let index = orderNumber % allGradients.count

        return allGradients[index]
    }
}
