//
//  ViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class OnboardingViewController: UIViewController {
    
    let coreDataStack: CoreDataStack = {
        //swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        return coreDataStack
    }()
    
    var viewModel: OnboardingViewModel?
    
    // Stack view
    private let stackView: UIStackView = {
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = MarginManager.smallMargin
        return $0
    }(UIStackView())
    
    // Circles 
    private let firstCircle: UIView = UIView()
    private let secondCircle: UIView = UIView()
    private let thirdCircle: UIView = UIView()
    private lazy var circles: [UIView] = [firstCircle, secondCircle, thirdCircle]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.nbaDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel = OnboardingViewModel(
            onboardingRepository: OnboardingRepositoryImpl(),
            coreDataStack: coreDataStack
        )
        // Retrieve data here
        generateData()
    }
    
    private func setupConstraints() {
        // Configure loading view
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circles.forEach {
            $0.layer.cornerRadius = MarginManager.smallMediumMargin/2
            $0.layer.masksToBounds = true
            $0.backgroundColor = UIColor.nbaTextColor
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: MarginManager.smallMediumMargin).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    private func generateData() {
        if let viewModel = self.viewModel, viewModel.shouldLoadData() {
            setupConstraints()
            viewModel.retrieveBigBatchOfPlayers { (success) in
                if success {
                    self.setRootViewController()
                }
            }
        } else {
            setRootViewController()
        }
    }
    
    private func animate() {
        let jumpDuration: Double = 0.30
        let delayDuration: Double = 1.25
        let totalDuration: Double = delayDuration + jumpDuration * 2
        
        let jumpRelativeDuration: Double = jumpDuration / totalDuration
        let jumpRelativeTime: Double = delayDuration / totalDuration
        let fallRelativeTime: Double = (delayDuration + jumpDuration) / totalDuration
        
        for (index, circle) in circles.enumerated() {
            let delay = jumpDuration * 2 * TimeInterval(index) / TimeInterval(circles.count)
            UIView.animateKeyframes(withDuration: totalDuration, delay: delay, options: [.repeat], animations: {
                UIView.addKeyframe(withRelativeStartTime: jumpRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y -= 30
                }
                UIView.addKeyframe(withRelativeStartTime: fallRelativeTime, relativeDuration: jumpRelativeDuration) {
                    circle.frame.origin.y += 30
                }
            })
        }
    }
    
    fileprivate func setRootViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TeamList", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
        let teamListNavigationVC =  UINavigationController.init(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = teamListNavigationVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
