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

    @IBInspectable var IconName : String = "Warning" {
        didSet {
            self._setup()
        }
    }

    @IBInspectable var SelectedColor : UIColor = UIColor.blackColor() {
        didSet {
            self._setup()
        }
    }
    
    @IBInspectable var UnselectedColor : UIColor = UIColor.blackColor() {
        didSet {
            self._setup()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self._setup()
    }
    
    private func setFontAwesome(icon: FontAwesome){
        let selectedImg : UIImage = UIImage.fontAwesomeIconWithName(icon, textColor: self.SelectedColor, size: CGSizeMake(20,20))
        let unselectedImg : UIImage = UIImage.fontAwesomeIconWithName(icon, textColor: self.UnselectedColor, size: CGSizeMake(20,20))
        self.image = unselectedImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.selectedImage = selectedImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    private func _setup(){
        if let icon : FontAwesome = FontAwesomeFactory.fetchFontAwesome(IconName)! {
            setFontAwesome(icon)
        } else {
            setFontAwesome(FontAwesome.Warning)
        }
    }

    
}
