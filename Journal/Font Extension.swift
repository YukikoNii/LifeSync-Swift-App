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
    
    static func systemSemiBold(_ size:CGFloat) -> Font{
        self.custom("TitilliumWeb-SemiBold", size: size)
        }
    // https://stackoverflow.com/questions/75984664/how-to-set-the-default-font-of-swiftui-text
}

extension UIFont {
    class var titillium: UIFont {
        return UIFont(name:"TitilliumWeb-Light", size:UIFont.preferredFont(forTextStyle: .body).pointSize)!
    } // https://atamo-dev.hatenablog.com/entry/2016/11/15/120634
    // Don't forget to unwrap.
    // Don't forget to specify the size. 
    
    class var titilliumSemiBold: UIFont {
        return UIFont(name:"TitilliumWeb-SemiBold", size:UIFont.preferredFont(forTextStyle: .body).pointSize)!
    }
}


