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
class FontAwesomeImageView: UIImageView {

    override func layoutSubviews() {
        self._setup()
        super.layoutSubviews()
    }

    @IBInspectable var IconName: String = "Stop" {
        didSet {
            self._setup()
        }
    }

    @IBInspectable var IconColor: UIColor = UIColor.blackColor() {
        didSet {
            self.tintColor = IconColor
            self._setup()
        }
    }

    override func prepareForInterfaceBuilder() {
        self._setup()
    }

    private func setFontAwesome(icon: FontAwesome) {
        self.image = UIImage.fontAwesomeIconWithName(icon, textColor: self.IconColor, size: self.frame.size)
    }

    private func _setup() {
        if let icon: FontAwesome = FontAwesomeFactory.fetchFontAwesome(IconName)! {
            setFontAwesome(icon)
        } else {
            setFontAwesome(FontAwesome.Warning)
        }
    }


}
