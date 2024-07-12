//
//  CKUserViewModel.swift
//  cloudKit-studies
//
//  Created by Anne Auzier on 04/07/24.
//

import CloudKit

class CKUserViewModel: ObservableObject {
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    
    init() {
        getiCloudStatus()
    }
    
    private func getiCloudStatus() {
        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
            DispatchQueue.main.async {
                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CKError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CKError.iCloudAccountNoDetermined.rawValue
                case .restricted:
                    self?.error = CKError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CKError.iCloudAccountUnknown.rawValue
                }
            }
        }
    }
    
    enum CKError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNoDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
}
