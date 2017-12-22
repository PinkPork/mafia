//
//  SideMenu.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/22/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol SideMenuObserver : class {
    func didBeginIn(point:UITouch)
    func didMovedTo(point:UITouch)
    func didEndedIo(point:UITouch)
}

class GestureRecognizer : UIGestureRecognizer {
    weak var observer:SideMenuObserver!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        observer.didBeginIn(point: touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        observer.didMovedTo(point: touches.first!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        observer.didEndedIo(point: touches.first!)
    }
}

class HideTapGestureRecognizer : UITapGestureRecognizer { var tag:Int? }

class SideMenu : NSObject, SideMenuObserver, UIGestureRecognizerDelegate {
    
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
    static let kSideMenuNotificationSwipeBegin  = "sidemenu.swipe.begin"
    static let kSideMenuNotificationSwipeEnd    = "sidemenu.swipe.ended"
    static let kSideMenuNotificationReopen      = "sidemenu.reopened"
    
    static var sharedInstance:SideMenu!
    
    var menuViewController:UIViewController?
    var menuOffsetSize:CGFloat = 0
    var useAnimations:Bool = true
    var useOverlayer:Bool = true
    var status:SideMenuStatus! = .Unknown
    var animationDuration:TimeInterval = 0.250
    
    var closeGesture:GestureRecognizer!
    var tapCloseGesture:HideTapGestureRecognizer!
    var initialPosition:CGPoint?
    var wasNotified:Bool = false
    var canToggle:Bool = false
    var overlayer:UIView!
    
    var windowSize:CGSize! {
        return UIScreen.main.bounds.size
    }
    var menuSize:CGSize! {
        return CGSize(
            width: windowSize.width - menuOffsetSize,
            height: windowSize.height
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
        var rect = CGRect.zero
        rect.size = windowSize
        
        overlayer = UIView(frame: rect)
        overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        closeGesture = GestureRecognizer()
        closeGesture.observer = self
        closeGesture.delegate = self
        closeGesture.cancelsTouchesInView = false
        
        tapCloseGesture = HideTapGestureRecognizer(target: self, action: #selector(close))
        tapCloseGesture.delegate = self
        tapCloseGesture.tag = 1
        
        if let menu = self.menuViewController {
            menu.view.layer.masksToBounds = false
            menu.view.layer.shadowColor = UIColor.black.cgColor
            menu.view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            menu.view.layer.shadowOpacity = 0.5
            menu.view.addGestureRecognizer(closeGesture)
            
            menu.view.frame = CGRect(
                x: -menuSize.width,
                y: 0,
                width: menuSize.width,
                height: menuSize.height
            )
            
            status = .Closed
        }
    }
    
    @objc func show(view:UIView!) throws {
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        
        print(windowSize)
        
        if useOverlayer {
            view.insertSubview(overlayer, aboveSubview: view)
            view.addGestureRecognizer(tapCloseGesture)
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
            y: 0,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    internal func buildFrame(status: SideMenuStatus) -> CGRect {
        self.status = status
        
        return CGRect(
            x: menuSize.width * status.rawValue,
            y: 0,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    internal func reopen() throws {
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        
        if useAnimations {
            UIView.animate(withDuration: animationDuration, animations: {
                menu.view.frame = self.buildFrame(status: .Opened)
                menu.view.layoutIfNeeded()
                menu.view.setNeedsLayout()
            }, completion: { (finished) in
                NotificationCenter
                    .default
                    .post(name: Notification.Name(rawValue:
                        SideMenu.kSideMenuNotificationReopen),
                        object: self
                )
            })
        } else {
            menu.view.frame = buildFrame(status: .Opened)
        }
    }
    
    internal func buildFrame(x: CGFloat) -> CGRect {
        return CGRect(
            x: x - windowSize.width,
            y: 0,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    func didMovedTo(point:UITouch) {
        let position = point.location(in: menuViewController!.view!.superview)
        let newFrame = buildFrame(x: position.x + menuOffsetSize)
        
        if let origin = initialPosition {
            if abs(origin.x - position.x) > 60 {
                canToggle = true
                
                let alpha = 0.85 - ((newFrame.origin.x / menuSize.width) * -1)
                
                if !wasNotified {
                    NotificationCenter
                        .default
                        .post(name: Notification.Name(rawValue:
                            SideMenu.kSideMenuNotificationSwipeBegin),
                            object: self
                    )
                    
                    wasNotified = true
                }
                
                if newFrame.origin.x < menuSize.width  {
                    UIView.animate(withDuration: 0.1) {
                        self.overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
                        self.menuViewController!.view.frame = newFrame
                    }
                }
            }
        }
    }
    
    func didBeginIn(point:UITouch) {
        wasNotified = false
        canToggle = false
        initialPosition = point.location(in: menuViewController!.view!.superview)
    }
    
    func didEndedIo(point:UITouch) {
        let newFrame = buildFrame(x: point.location(in: menuViewController!.view!.superview).x)
        
        if canToggle {
            if newFrame.origin.x < -(windowSize.width / 2) {
                try! close()
            } else {
                try! reopen()
            }
        }
        
        NotificationCenter
            .default
            .post(name: Notification.Name(rawValue:
                SideMenu.kSideMenuNotificationSwipeEnd),
                object: self
        )
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let position = touch.location(in: menuViewController!.view!.superview)
        
        if status == SideMenuStatus.Closed {
            return false
        }
        
        if gestureRecognizer.isKind(of: HideTapGestureRecognizer.self) {
            
            if touch.view!.isDescendant(of: menuViewController!.view) {
                return false
            }
        }
        
        if let origin = initialPosition {
            if abs(origin.x - position.x) < 60 && abs(origin.y - position.y) < 20 {
                return false
            }
        }
        return true
    }
}
