//
//  CustomTextField.swift
//  DesignSystem
//
//  Created by Theo Sementa on 10/11/2025.
//

import SwiftUI

public struct CustomTextFieldView: View {
    
    // Builder
    @Binding var text: String
    var config: Configuration
    
    @FocusState private var isFocused: Bool
    
    public init(text: Binding<String>, config: Configuration) {
        self._text = text
        self.config = config
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(config.title)
                .padding(.leading, Spacing.small)
                .font(.system(size: 12, weight: .regular))
            
            TextField(config.placeholder, text: $text)
                .focused($isFocused)
                .customFont(.Body.medium)
                .padding(Spacing.regular)
                .roundedRectangleBorder(
                    Color.Background.bg100,
                    radius: CornerRadius.medium,
                    lineWidth: 1,
                    strokeColor: Color.Background.bg200
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            isFocused.toggle()
        }
    }
}

// MARK: - Utils
extension CustomTextFieldView {
    
    public struct Configuration {
        var title: String
        var placeholder: String
        
        public init(
            title: String,
            placeholder: String
        ) {
            self.title = title
            self.placeholder = placeholder
        }
    }
    
}
