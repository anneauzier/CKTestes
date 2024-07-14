//
//  CKPushNotificationView.swift
//  cloudKit-studies
//
//  Created by Anne Auzier on 14/07/24.
//

import SwiftUI

struct CKPushNotificationView: View {
    
    @StateObject private var viewModel = CKPushNotificationViewModel()
    
    var body: some View {
        VStack(spacing: 40) {

            Button("Request notification permissions") {
                viewModel.requestNotificationPermission()
            }
            
            Button("Subscribe to notifications") {
                viewModel.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                viewModel.unsubscribeToNotifications()
            }
        }
    }
}

#Preview {
    CKPushNotificationView()
}
