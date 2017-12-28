//
//  SideMenu.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/22/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass




class HideTapGestureRecognizer : UITapGestureRecognizer { var tag:Int? }

class SideMenu : NSObject {
    
    enum SideMenuError : Error{
        case InvalidMenuContext
    }
    
    enum SideMenuStatus : CGFloat {
        case Opened     =  0
        case Closed     = -1.0
        case Unknown    =  1.0
    }
    
    static let kSideMenuNotificationOpen        = "sidemenu.opened"
    static let kSideMenuNotificationClose       = "sidemenu.closed"    
    
    static var sharedInstance:SideMenu!
    
    var menuViewController: MenuViewController?
    var menuOffsetSize:CGFloat = 0
    var useAnimations:Bool = true
    var useOverlayer:Bool = true
    var status:SideMenuStatus! = .Unknown
    var animationDuration:TimeInterval = 0.250
    
    var initialPosition:CGPoint?
    var wasNotified:Bool = false
    var canToggle:Bool = false
    var overlayer:UIView!
    
    var menuSize:CGSize! {
        return CGSize(
            width: Utils.UI.screenWidth - menuOffsetSize,
            height: Utils.UI.screenHeight - Utils.UI.navigationBarheight
        )
    }
    
    typealias BuilderClosure = (_ menu: SideMenu) -> ()
    typealias MenuCompletionClosure = () -> ()
    
    init(context: BuilderClosure) {
        super.init()
        
        context(self)
        
        build()
        
        SideMenu.sharedInstance = self
    }
        
    internal func build() {
        let rect = CGRect(x: 0, y: Utils.UI.navigationBarheight, width: Utils.UI.screenWidth, height: menuSize.height)
        
        overlayer = UIView(frame: rect)
        overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        if let menu = self.menuViewController {
            menu.view.layer.masksToBounds = false
            menu.view.layer.shadowColor = UIColor.black.cgColor
            menu.view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            menu.view.layer.shadowOpacity = 0.5
            
            menu.view.frame = CGRect(
                x: -menuSize.width,
                y: Utils.UI.navigationBarheight,
                width: menuSize.width,
                height: menuSize.height
            )
            
            status = .Closed
        }
    }
    
    @objc func show(view:UIView!) throws {
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        if self.status == .Opened {
            try! self.close()
            return
        }
        
        if useOverlayer {
            view.insertSubview(overlayer, aboveSubview: view)
        }
        
        view.insertSubview(menu.view, aboveSubview: view)
        
        if useAnimations {
            UIView.animate(withDuration: animationDuration, animations: {
                self.overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
                menu.view.frame = self.buildFrame(status: .Opened)
                menu.view.layoutIfNeeded()
                menu.view.setNeedsLayout()
            }, completion: { (finished) in
                NotificationCenter
                    .default
                    .post(name: Notification.Name(rawValue:
                        SideMenu.kSideMenuNotificationOpen),
                        object: self
                )
                self.status = .Opened
            })
        } else {
            menu.view.frame = buildFrame(status: .Opened)
            NotificationCenter
                .default
                .post(name: Notification.Name(rawValue:
                    SideMenu.kSideMenuNotificationOpen),
                    object: self
            )
            self.status = .Opened
        }
    }
    
    @objc func close() throws {
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        
        if useAnimations {
            UIView.animate(withDuration: animationDuration, animations: {
                self.overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                self._close()
                menu.view.layoutIfNeeded()
                menu.view.setNeedsLayout()
            }, completion: { (finished) in
                menu.view.removeFromSuperview()
                self.overlayer.removeFromSuperview()
                NotificationCenter
                    .default
                    .post(name: Notification.Name(rawValue:
                        SideMenu.kSideMenuNotificationClose),
                        object: self
                )
                self.status = .Closed
            })
        } else {
            _close()
            menu.view.removeFromSuperview()
            NotificationCenter
                .default
                .post(name: Notification.Name(rawValue:
                    SideMenu.kSideMenuNotificationClose),
                    object: self
            )
            status = .Closed
        }
    }
    
    internal func _close() {
        menuViewController!.view.frame = CGRect(
            x: -menuSize.width,
            y: Utils.UI.navigationBarheight,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    func buildFrame(status: SideMenuStatus) -> CGRect {
        self.status = status
        
        return CGRect(
            x: menuSize.width * status.rawValue,
            y: Utils.UI.navigationBarheight,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    func buildFrame(x: CGFloat) -> CGRect {
        return CGRect(
            x: x - Utils.UI.screenWidth,
            y: Utils.UI.navigationBarheight,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    func didBeginIn(point:UITouch) {
        wasNotified = false
        canToggle = false
        initialPosition = point.location(in: menuViewController!.view!.superview)
    }
}
