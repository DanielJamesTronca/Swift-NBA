//
//  ViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: OnboardingViewModel = OnboardingViewModel(onboardingRepository: OnboardingRepositoryImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveBigBatchOfPlayers()
    }
    
    private func retrieveBigBatchOfPlayers() {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        for i in 0 ..< 5 {
            dispatchGroup.enter()
            self.viewModel.retrieveAllPlayers(currentPage: i) { (success) in
                if success {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished all requests!")
            let storyBoard: UIStoryboard = UIStoryboard(name: "TeamList", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TeamListViewController") as! TeamListViewController
            let navi =  UINavigationController.init(rootViewController: newViewController)
            UIApplication.shared.windows.first?.rootViewController = navi
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
        //        super.viewWillAppear(animated)
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //            return
        //        }
        //
        //        let managedContext = appDelegate.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Player")
        //
        //        do {
        //            player = try managedContext.fetch(fetchRequest)
        //            print("DONE")
        //        } catch let error as NSError {
        //            print("Could not fetch. \(error), \(error.userInfo)")
        //        }
//    }
}
