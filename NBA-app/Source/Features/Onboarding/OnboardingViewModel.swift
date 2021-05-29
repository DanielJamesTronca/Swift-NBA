//
//  OnboardingViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class OnboardingViewModel {
    
    private var pageLimit: Int = 100
    
    private let coreDataStack: CoreDataStack
    
    // Beer repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Beer repository initialization
    init(onboardingRepository: OnboardingRepository, coreDataStack: CoreDataStack) {
        self.onboardingRepository = onboardingRepository
        self.coreDataStack = coreDataStack
    }
    
    func shouldLoadData() -> Bool {
        // TODO: Remove this "magic number"!!
        if self.onboardingRepository.getRecordsCount(coreDataStack: coreDataStack) <= 2000 {
            return true
        } else {
            return false
        }
    }
    
    func retrieveBigBatchOfPlayers(_ completionHandler: @escaping (Bool) -> Void) {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        // We know there are almost 35 pages.
        // For the time being we retrieve data from the first 25.
        // We can improve this solution by getting this data run-time.
        // TODO: Remove this "magic number"!!
        for i in 0 ... 25 {
            dispatchGroup.enter()
            self.retrieveAllPlayers(currentPage: i) { (success) in
                // Move on
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished all requests!")
            completionHandler(true)
        }
    }
    
    private func retrieveAllPlayers(currentPage: Int, _ completionHandler: @escaping (Bool) -> Void) {
        self.onboardingRepository.retrievePlayers(currentPage: currentPage, pageLimit: self.pageLimit) { (response) in
            switch response {
            case .success(let players):
                players.data.forEach { (player) in
                    DispatchQueue.main.async {
                        if !self.onboardingRepository.someEntityExists(coreDataStack: self.coreDataStack, id: player.id, fieldName: "playerId") {
                            self.onboardingRepository.save(
                                coreDataStack: self.coreDataStack,
                                name: "\(player.firstName) \(player.lastName)",
                                teamId: Int64(player.team.id),
                                playerId: Int64(player.id),
                                teamFullName: player.team.fullName,
                                position: player.position
                            )
                        }
                    }
                }
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
}
