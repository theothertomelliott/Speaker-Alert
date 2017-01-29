//
//  FontAwesomeButton.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/26/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit
import FontAwesome_swift

@IBDesignable
class FontAwesomeButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var IconName: String = "Play" {
        didSet {
            self._setup()
        }
    }

    @IBInspectable var IconSize: CGFloat = 20.0 {
        didSet {
            self._setup()
        }
    }

    @IBInspectable var AdditionalText: String = "" {
        didSet {
            self._setup()
        }
    }

    #if !TARGET_INTERFACE_BUILDER
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._setup()
    }
    #endif

    override func prepareForInterfaceBuilder() {
        self._setup()
    }
    
    func setIconAndAccessibility(_ name: String, aId: String? = nil) {
        self.IconName = name
        if let i: String = aId {
            self.accessibilityIdentifier = i
            self.accessibilityLabel = i
            self.accessibilityHint = i
        } else {
            self.accessibilityIdentifier = name
            self.accessibilityLabel = name
            self.accessibilityHint = name
        }
    }

    fileprivate func getFullString(_ icon: FontAwesome, additional: String) -> String {
        return String.fontAwesomeIcon(name: icon) +
            ( additional.characters.count > 0 ? (" " + additional) : "" )
    }

    fileprivate func setFontAwesome(_ icon: FontAwesome) {

        let str: String = getFullString(icon, additional: AdditionalText)

        setTitle(str, for: UIControlState.disabled)
        setTitle(str, for: UIControlState.highlighted)
        setTitle(str, for: UIControlState())
        setTitle(str, for: UIControlState.selected)
    }

    fileprivate func _setup() {

        self.titleLabel!.font = UIFont.fontAwesome(ofSize: IconSize)

        if let icon: FontAwesome = FontAwesomeFactory.fetchFontAwesome(IconName) {
            setFontAwesome(icon)
        } else {
           setFontAwesome(FontAwesome.warning)
        }
    }

}
