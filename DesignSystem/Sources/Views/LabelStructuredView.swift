//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 11/11/2025.
//

import SwiftUI
import Utilities

public struct LabelStructuredView: View {
    
    // MARK: Dependencies
    let title: String
    let value: String
    
    // MARK: Init
    public init(
        title: String,
        value: String
    ) {
        self.title = title
        self.value = value
    }
    
    // MARK: - View
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(title)
                .customFont(.Label.large)
            
            Text(value)
                .customFont(.Body.large)
        }
        .fullWidth(.leading)
    }
}

// MARK: - Preview
#Preview {
    LabelStructuredView(
        title: "Preview",
        value: "1920 x 1080"
    )
}
