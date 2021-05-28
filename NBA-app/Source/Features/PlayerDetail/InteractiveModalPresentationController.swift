//
//  InteractiveModalPresentationController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import Foundation
import UIKit

final class InteractiveModalPresentationController: UIPresentationController {
    
    // Custom value to handle sheet size
    private let presentedYOffset: CGFloat = 300
    
    // Cuurent state
    private var state: ModalScaleState = .interaction
    
    // Programmatically set dimming view behind beer detail!
    private lazy var dimmingView: UIView! = {
        guard let container = containerView else {
            return nil
        }
        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTap(tap:))
            )
        )
        return view
    }()
    
    // Override init
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        // We can add Pan gesture here
    }
    
    // Handle did tap gesture
    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // We override the frame presentation with out own size
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        return CGRect(
            x: 0,
            y: container.bounds.height - self.presentedYOffset,
            width: container.bounds.width,
            height: self.presentedYOffset
        )
    }
    
    // Handle presentation transition
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
              let coordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    // Handle dismissal transition
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
