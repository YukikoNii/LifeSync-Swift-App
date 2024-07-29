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
