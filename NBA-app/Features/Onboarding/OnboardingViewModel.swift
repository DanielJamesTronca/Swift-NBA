//
//  OnboardingViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation
import CoreData
import UIKit

class OnboardingViewModel {
    
    // Beer repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Beer repository initialization
    init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
    
    func retrieveAllPlayers(currentPage: Int, completionHandler: @escaping (Bool) -> Void) {
        self.onboardingRepository.retrievePlayers(currentPage: currentPage) { (response) in
            switch response {
            case .success(let players):
                players.data.forEach { (player) in
                    DispatchQueue.main.async {
                        self.save(name: player.firstName)
                    }
                }
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Player", in: managedContext)!
        let player = NSManagedObject(entity: entity, insertInto: managedContext)
        player.setValue(name, forKeyPath: "completeName")
        do {
            try managedContext.save()
            //            self.player.append(player)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
