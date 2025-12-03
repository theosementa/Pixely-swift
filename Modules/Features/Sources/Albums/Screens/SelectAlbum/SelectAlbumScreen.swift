//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 03/12/2025.
//

import SwiftUI
import DesignSystem
import Models

public struct SelectAlbumScreen: View {
    
    @Binding var albumSelectedId: UUID
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    // MARK: Init
    public init(albumSelectedId: Binding<UUID>) {
        self._albumSelectedId = albumSelectedId
        self._viewModel = State(wrappedValue: ViewModel(albumSelectedId: albumSelectedId.wrappedValue))
    }
    
    // MARK: - View
    public var body: some View {
        List {
            Section {
                ForEach(viewModel.parentAlbumsSelectable) { album in
                    Button {
                        viewModel.albumSelectedId = album.id
                    } label: {
                        HStack {
                            Text(album.name)
                                .fullWidth(.leading)
                            if viewModel.albumSelected?.id == album.id {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
            } header: {
                Text("Albums")
            }
            
            Section {
                ForEach(viewModel.subAlbumsSelectable) { subAlbum in
                    Button {
                        viewModel.albumSelectedId = subAlbum.id
                    } label: {
                        HStack {
                            Text(subAlbum.name)
                                .fullWidth(.leading)
                            if viewModel.albumSelected?.id == subAlbum.id {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
            } header: {
                Text("Subalbums")
            }
        }
        .onChange(of: viewModel.albumSelectedId) {
            self.albumSelectedId = viewModel.albumSelectedId
        }
    }
    
}

// MARK: - Preview
#Preview {
    SelectAlbumScreen(albumSelectedId: .constant(AlbumModel.noAlbum.id))
}
