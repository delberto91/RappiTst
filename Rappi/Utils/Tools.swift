//
//  Tools.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/19/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import Foundation
import UIKit
open class Tools {
    
    //Static func to present native alert in any controller
    static func showAlert(title: String, message: String, titleForTheAction: String, in vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: titleForTheAction, style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}

enum Categories : String  {
    case TopRated = "top_rated"
    case Upcomig = "upcoming"
    case Popular = "popular"
}
open class FadePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
     open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to)
            else {
                return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
