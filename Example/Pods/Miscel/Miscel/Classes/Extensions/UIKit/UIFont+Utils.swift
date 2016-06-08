//
//  UIFont.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension UIFont {
    public var monospacedDigitFont: UIFont {
        let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
        let oldFontDescriptor = fontDescriptor()
        let newFontDescriptor = oldFontDescriptor.fontDescriptorByAddingAttributes(fontDescriptorAttributes)

        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}
