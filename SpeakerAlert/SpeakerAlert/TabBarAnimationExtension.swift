//
//  TabBarAnimationExtension.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/11/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


extension UIViewController {

    func tabBarIsVisible() -> Bool {
        return self.tabBarController?.tabBar.frame.origin.y < self.view.frame.maxY
    }

    // Code from: http://bit.ly/1JRtVVb
    func setTabBarVisible(_ visible: Bool, animated: Bool) {

        /* This cannot be called before viewDidLayoutSubviews(),
         because the frame is not set before this time */

        // bail if the current state matches the desired state
        if tabBarIsVisible() == visible { return }

        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)

        // zero duration means no animation
        let duration: TimeInterval = (animated ? 0.3 : 0.0)

        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }) 
        }
    }

}
