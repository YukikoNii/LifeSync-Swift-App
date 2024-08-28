//
//  Color Extension.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/08/28.
//

import SwiftUI

extension UIColor {
    
    convenience init(light: UIColor, dark: UIColor) {
        self.init{ traitCollection in
            return traitCollection.userInterfaceStyle == .light ? light : dark
        }
    } // src: ChatGPT
    
    public class var tertiary: UIColor {
        return UIColor(red: 43/255, green: 44/255, blue: 42/255, alpha: 1.0)
    }
    
    public class var lightPrim: UIColor { // Pink
        return UIColor(red: 250/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }
    
    public class var darkPrim: UIColor { // Dark blue
        return UIColor(red: 40/255, green: 67/255, blue: 120/255, alpha: 1.0)
    }
    
    public class var lightSec: UIColor { // Dark blue
        return UIColor(red: 40/255, green: 67/255, blue: 120/255, alpha: 1.0)
    }
    
    public class var darkSec: UIColor { // Pink
        return UIColor(red: 250/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }
    
    public class var lightTint: UIColor { // Lighter blue
        return UIColor(red: 242/255, green: 209/255, blue: 209/255, alpha: 1.0)
    }
    
    public class var darkTint: UIColor { // Light pink
        return UIColor(red: 65/255, green: 105/255, blue: 173/255, alpha: 1.0)
    }
    
    public class var lightShade: UIColor { // Dark pink
        return UIColor(red: 191/255, green: 147/255, blue: 147/255, alpha: 1.0)
    }
    
    public class var darkShade: UIColor { // Darker blue
        return UIColor(red: 22/255, green: 45/255, blue: 92/255, alpha: 1.0)
    }
    
}


