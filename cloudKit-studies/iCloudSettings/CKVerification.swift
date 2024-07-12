//
//  CKVerification.swift
//  cloudKit-studies
//
//  Created by Anne Auzier on 04/07/24.
//

import SwiftUI

import SwiftUI
import CloudKit

struct CKVerification: View {

    @StateObject private var viewModel = CKUserViewModel()

    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(viewModel.isSignedInToiCloud.description.uppercased())")
                .padding()
            Text(viewModel.error)
        }
        .padding()
    }
}

#Preview {
    CKVerification()
}
