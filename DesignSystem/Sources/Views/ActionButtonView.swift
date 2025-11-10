//
//  ActionButtonView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 10/11/2025.
//

import SwiftUI

public struct ActionButtonView: View {
    
    // MARK: Dependencies
    let title: String
    let action: () async -> Void
    
    // MARK: Init
    public init(
        title: String,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(title)
                .customFont(.Body.mediumBold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(Spacing.standard)
                .background(Color.blue, in: .rect(cornerRadius: CornerRadius.large, style: .continuous))
        }
    }
}
