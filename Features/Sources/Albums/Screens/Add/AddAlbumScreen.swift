//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI

public struct AddAlbumScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    // MARK: Init
    public init(albumId: UUID? = nil) {
        self._viewModel = State(wrappedValue: .init(albumId: albumId))
    }
    
    // MARK: - View
    public var body: some View {
        VStack {
            TextField("Album name", text: $viewModel.name)
            
            Button {
                viewModel.createAlbum()
            } label: {
                Text("Create")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddAlbumScreen()
}
