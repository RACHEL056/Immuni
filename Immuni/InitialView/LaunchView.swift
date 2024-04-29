//
//  LaunchView.swift
//  Immuni
//
//  Created by 박민정 on 4/15/24.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Image("ImmuniLogo")
                .resizable()
                .frame(height: 120)
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
    }
}

#Preview {
    LaunchView()
}
