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
    let config: Configuration
    let action: () async -> Void
    
    // MARK: Init
    public init(
        title: String,
        config: Configuration,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.config = config
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack(spacing: Spacing.small) {
                if let icon = config.icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .customFont(.Body.mediumBold)
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: config.style.maxWidth)
            .padding(Spacing.standard)
            .background(Color.blue, in: .rect(cornerRadius: CornerRadius.large, style: .continuous))
        }
    }
}

// MARK: - Utils
public enum ActionButtonStyle {
    case classic, small
    
    var maxWidth: CGFloat? {
        return self == .classic ? .infinity : nil
    }
}

extension ActionButtonView {
    
    public struct Configuration {
        let style: ActionButtonStyle
        let icon: String?
        
        public init(
            style: ActionButtonStyle,
            icon: String? = nil
        ) {
            self.style = style
            self.icon = icon
        }
    }
    
}
