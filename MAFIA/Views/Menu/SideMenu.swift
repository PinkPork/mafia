//
//  SideMenu.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/22/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class SideMenu: NSObject {
    
    enum SideMenuError: Error {
        case InvalidMenuContext
    }
    
    enum SideMenuStatus: CGFloat {
        case Opened = 0
        case Closed = -1.0
        case Unknown = 1.0
    }
    
    static var sharedInstance: SideMenu!
    
    var menuViewController: MenuViewController?
    var menuOffsetSize: CGFloat = 0
    var useAnimations: Bool = true
    var useOverlayer: Bool = true
    var status: SideMenuStatus = .Closed
    var animationDuration: TimeInterval = 0.250
    
    var initialPosition: CGPoint?
    var wasNotified: Bool = false
    var canToggle: Bool = false
    var overlayer: UIView!
    
    var menuSize: CGSize! {
        return CGSize(
            width: Utils.UI.screenWidth - menuOffsetSize,
            height: Utils.UI.screenHeight - Utils.UI.navigationBarheight
        )
    }
    
    typealias BuilderClosure = (_ menu: SideMenu) -> Void
    typealias MenuCompletionClosure = () -> Void

    @discardableResult
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
        
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(animateMenu))
        overlayer.addGestureRecognizer(closeTapGesture)
        
        if let menu = self.menuViewController {
            menu.view.layer.masksToBounds = false
            menu.view.layer.shadowColor = UIColor.black.cgColor
            menu.view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            menu.view.layer.shadowOpacity = 0.5
            
            menu.view.frame = buildFrame(status: status)
        }
    }
    
    @objc func show(view: UIView!) throws {
        defer {
            try! animateMenu()
        }
        
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        
        if self.status == .Opened { return }
        
        if useOverlayer {
            view.insertSubview(overlayer, aboveSubview: view)
        }
        view.insertSubview(menu.view, aboveSubview: view)
        
    }
    
    @objc func animateMenu() throws {
        guard let menu = menuViewController else { throw SideMenuError.InvalidMenuContext }
        
        UIView.animate(withDuration: animationDuration, animations: {
            switch self.status {
            case .Opened:
                self.close()
            default:
                self.open()
            }
            menu.view.frame = self.buildFrame(status: self.status)
            menu.view.layoutIfNeeded()
            menu.view.setNeedsLayout()
        }, completion: { (finished) in
            if self.status == .Closed {
                menu.view.removeFromSuperview()
                self.overlayer.removeFromSuperview()
            }
        })
    }
    
    func open() {
        self.overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        self.status = .Opened
    }
    
    func close() {
        self.overlayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.status = .Closed
    }
    
    func buildFrame(status: SideMenuStatus) -> CGRect {
        
        return CGRect(
            x: menuSize.width * status.rawValue,
            y: Utils.UI.navigationBarheight,
            width: menuSize.width,
            height: menuSize.height
        )
    }
    
    func didBeginIn(point: UITouch) {
        wasNotified = false
        canToggle = false
        guard let menu = menuViewController else { return }
        initialPosition = point.location(in: menu.view?.superview)
    }
}
