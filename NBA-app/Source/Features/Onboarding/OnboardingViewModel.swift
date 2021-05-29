//
//  OnboardingViewModel.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

class OnboardingViewModel {
    
    private var pageLimit: Int = 100
    
    private let dataProvider: TeamPlayerProvider
        
    // Onboarding repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Onboarding repository initialization
    init(onboardingRepository: OnboardingRepository, dataProvider: TeamPlayerProvider) {
        self.onboardingRepository = onboardingRepository
        self.dataProvider = dataProvider
    }
    
    func shouldLoadData() -> Bool {
        // TODO: Remove this "magic number"!!
        let magicNumber: Int = 2000
        if self.onboardingRepository.getTotalPlayerCount(dataProvider: dataProvider) <= magicNumber {
            return true
        } else {
            return false
        }
    }
    
    func retrieveBigBatchOfPlayers(_ completionHandler: @escaping (Bool) -> Void) {
        let dispatchGroup: DispatchGroup = DispatchGroup()
        // We know there are almost 35 pages.
        // For the time being we retrieve data from the first 20 to avoid extra loading
        // We can improve this solution by getting this data run-time.
        // TODO: Remove this "magic number"!!
        let magicNumber: Int = 25
        for i in 0 ... magicNumber {
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
                        if !self.onboardingRepository.checkIfDataContainsPlayerId(dataProvider: self.dataProvider, id: player.id) {
                            self.onboardingRepository.addPlayer(
                                dataProvider: self.dataProvider,
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
