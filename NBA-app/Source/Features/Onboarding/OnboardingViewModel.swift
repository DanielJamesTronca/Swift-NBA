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
    
    private var pageLimit: Int = 100
    
    var totalPageNumber: Int?
        
    // Beer repository to handle data
    private let onboardingRepository: OnboardingRepository
    // Beer repository initialization
    init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
    
    func retrieveAllPlayers(currentPage: Int, completionHandler: @escaping (PlayersJSONResponse?) -> Void) {
        self.onboardingRepository.retrievePlayers(currentPage: currentPage, pageLimit: self.pageLimit) { (response) in
            switch response {
            case .success(let players):
                self.totalPageNumber = players.meta.totalPages
                completionHandler(players)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil)
            }
        }
    }
}
