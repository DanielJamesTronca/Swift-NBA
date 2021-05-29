//
//  ErrorExtensions.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import Foundation

extension Error {
    
    // TODO: Add differnt scenarios
    func mapNetworkErrorToUIErrorData(errorCode: Int32) -> ErrorStructure {
        switch errorCode {
        case 404:
            // Add correct strings based on error. For the time being we use a generic one since it is mocked
            return ErrorStructure(
                errorMessage: "generic_error_title".localized,
                errorDescription: "generic_error_description".localized,
                code: 404
            )
        default:
            return ErrorStructure(
                errorMessage: "generic_error_title".localized,
                errorDescription: "generic_error_description".localized,
                code: 100
            )
        }
    }
}
