//
//  FontAwesomeView.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/23/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import FontAwesome_swift

@IBDesignable
class FontAwesomeTabBarItem: UITabBarItem {

    fileprivate var faIcon: FontAwesome?

    @IBInspectable var IconName: String = "Warning" {
        didSet {
            self._setup()
        }
    }

    override func prepareForInterfaceBuilder() {
        self._setup()
    }

    fileprivate func setFontAwesome(_ icon: FontAwesome) {

        let selectedImg: UIImage = UIImage.fontAwesomeIcon(
            name: icon,
            textColor: UIColor.white,
            size: CGSize(width: 20, height: 20))
        self.selectedImage = selectedImg.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = selectedImg.withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        var attrs = UITabBarItem.appearance().titleTextAttributes(for: UIControlState())
        if let color = attrs?[NSForegroundColorAttributeName],
            let unselectedImg: UIImage = UIImage.fontAwesomeIcon(
                name: icon,
                textColor: (color as? UIColor)!,
                size: CGSize(width: 20, height: 20)) {
            self.image = unselectedImg.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
    }

    fileprivate func _setup() {
        if let icon: FontAwesome = FontAwesomeFactory.fetchFontAwesome(IconName) {
            setFontAwesome(icon)
        } else {
            setFontAwesome(FontAwesome.warning)
        }
    }


}
