//
//  Font Extension.swift
//  Journal
//
//  Created by Yukiko Nii on 2024/07/25.
//

import SwiftUI

extension Font {
    static func system(_ size:CGFloat) -> Font{
        self.custom("TitilliumWeb-Light", size: size)
        }
    // https://stackoverflow.com/questions/75984664/how-to-set-the-default-font-of-swiftui-text
}

extension UIFont {
    class var titillium: UIFont {
        return UIFont(name:"TitilliumWeb-Light", size:UIFont.preferredFont(forTextStyle: .body).pointSize)!
    } // https://atamo-dev.hatenablog.com/entry/2016/11/15/120634
    // Don't forget to unwrap.
    // Don't forget to specify the size. 
}

extension UIColor {
    public class var tertiary: UIColor {
        return UIColor(red: 43/255, green: 44/255, blue: 42/255, alpha: 1.0)
    }
}
