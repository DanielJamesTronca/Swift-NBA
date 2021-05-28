//
//  ViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
        
    let coreDataStack: CoreDataStack = {
        //swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        return coreDataStack
    }()
    
    var viewModel: OnboardingViewModel?
    
    private let stackView: UIStackView = {
         $0.distribution = .fill
         $0.axis = .horizontal
         $0.alignment = .center
         $0.spacing = 10
         return $0
     }(UIStackView())
    
    private let firstCircle = UIView()
    private let secondCircle = UIView()
    private let thirdCircle = UIView()
    private lazy var circles = [firstCircle, secondCircle, thirdCircle]
    
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
        // We know that there is a total of almost 3400 player.
        // For the time being we retrieve at least 2000 of them.
        // We can improve this solution by getting this data run-time.
        if self.getRecordsCount() <= 2000 {
            setupConstraints()
            self.retrieveBigBatchOfPlayers()
        } else {
            setRootViewController()
        }
    }
    
    private func setupConstraints() {
        // Configure loading view
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circles.forEach {
            $0.layer.cornerRadius = 20/2
            $0.layer.masksToBounds = true
            $0.backgroundColor = UIColor.nbaTextColor
            stackView.addArrangedSubview($0)
            $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }
    }
    
    private func animate() {
        let jumpDuration: Double = 0.30
        let delayDuration: Double = 1.25
        let totalDuration: Double = delayDuration + jumpDuration*2

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
    
    private func retrieveBigBatchOfPlayers() {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        // We know there are almost 35 pages.
        // For the time being we retrieve data from the first 25.
        // We can improve this solution by getting this data run-time.
        for i in 1 ..< 25 {
            dispatchGroup.enter()
            self.viewModel?.retrieveAllPlayers(currentPage: i, completionHandler: { (success) in
                if success {
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished all requests!")
            self.setRootViewController()
        }
    }
    
    func getRecordsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerCoreDataClass")
        do {
            let count = try coreDataStack.managedContext.count(for: fetchRequest)
            return count
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    fileprivate func setRootViewController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TeamList", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
        newViewController.coreDataStack = self.coreDataStack
        let navi =  UINavigationController.init(rootViewController: newViewController)
        UIApplication.shared.windows.first?.rootViewController = navi
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
