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

    private var faIcon : FontAwesome?
    
    @IBInspectable var IconName : String = "Warning" {
        didSet {
            self._setup()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        self._setup()
    }
    
    private func setFontAwesome(icon: FontAwesome){
        
        let selectedImg : UIImage = UIImage.fontAwesomeIconWithName(icon, textColor: UIColor.whiteColor(), size: CGSizeMake(20,20))
        self.selectedImage = selectedImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.image = selectedImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        let attrs = UITabBarItem.appearance().titleTextAttributesForState(UIControlState.Normal)
        if let color = attrs?[NSForegroundColorAttributeName] {
            let unselectedImg : UIImage = UIImage.fontAwesomeIconWithName(icon, textColor: color as! UIColor, size: CGSizeMake(20,20))
            self.image = unselectedImg.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }
    
    private func _setup(){
        if let icon : FontAwesome = FontAwesomeFactory.fetchFontAwesome(IconName)! {
            setFontAwesome(icon)
        } else {
            setFontAwesome(FontAwesome.Warning)
        }
    }

    
}
