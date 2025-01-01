//
//  PushMenuTransition.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 4/20/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

/**
 * Makes a transition used in the MenuViewController
 */
class PushMenuTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let originFrame: CGRect
    private let transitionDuration: TimeInterval = 0.3
    private let relativeDuration: TimeInterval = 1.0
    private var isDismissing: Bool

    /**
     * Creates UIViewControllerAnimatedTransition
     * - parameters:
     *   - originFrame: Starting point of the animation
     *   - dismissing: `true` if the transition is from a dismissing `ViewController`, otherwise default `false`
     */
    init(originFrame: CGRect, dismissing: Bool = false) {
        self.originFrame = originFrame
        isDismissing = dismissing
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // Gets the viewController to present and takes a snapshot of its view
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        // Select the menu view controller.
        let viewControllerToAnimate = isDismissing ? fromViewController : toViewController

        // Selects ViewController which is presenting MenuViewController
        let viewControllerToFadeInOut = isDismissing ? toViewController : fromViewController
        let containerView = transitionContext.containerView

        // Adds MenuViewController to the containerView
        if !isDismissing {
            containerView.addSubview(viewControllerToAnimate.view)
            viewControllerToAnimate.view.frame.origin.x = -self.originFrame.width
        }

        let duration = transitionDuration(using: transitionContext)

        let animation = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.relativeDuration) {
                viewControllerToAnimate.view.frame.origin.x = self.isDismissing ? -self.originFrame.width : 0.0
                viewControllerToFadeInOut.view.alpha = self.isDismissing ? 1.0 : 0.7
            }
        }

        let completion: (Bool) -> Void = { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: UIView.KeyframeAnimationOptions.calculationModeCubic,
            animations: animation,
            completion: completion
        )
    }

}
