//
//  AssetsListView.swift
//  Features
//
//  Created by Theo Sementa on 02/12/2025.
//

import Photos
import SwiftUI
import Navigation

struct AssetsListView: View {
    let assets: [PHAsset]
    let columnsCount: Int = 5
    @Binding var assetsSelected: [PHAsset]
    let isSelectModeEnabled: Bool
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: Computed variables
    private var chunkedAssets: [[PHAsset]] {
        stride(from: 0, to: assets.count, by: columnsCount).map {
            Array(assets[$0..<min($0 + columnsCount, assets.count)])
        }
    }
    
    // MARK: - View
    var body: some View {
        List {
            ForEach(chunkedAssets.indices, id: \.self) { rowIndex in
                HStack(spacing: 2) {
                    ForEach(chunkedAssets[rowIndex], id: \.localIdentifier) { asset in
                        AssetGridCellView(
                            asset: asset,
                            isSelected: isSelected(for: asset) && isSelectModeEnabled
                        )
                        .onTapGesture {
                            if isSelectModeEnabled {
                                toggleSelection(for: asset)
                            } else {
                                router.push(.asset(.assetDetail(asset: asset)))
                            }
                        }
                    }
                    
                    if chunkedAssets[rowIndex].count < columnsCount {
                        ForEach(0..<(columnsCount - chunkedAssets[rowIndex].count), id: \.self) { _ in
                            Color.clear
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1))
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    private func toggleSelection(for asset: PHAsset) {
        if assetsSelected.contains(asset) {
            assetsSelected.removeAll(where: { $0.id == asset.id })
        } else {
            assetsSelected.append(asset)
        }
    }
    
    private func isSelected(for asset: PHAsset) -> Bool {
        return assetsSelected.contains(where: { $0.id == asset.id })
    }
}
