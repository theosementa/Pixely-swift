//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 11/11/2025.
//

import SwiftUI
import Models
import DesignSystem

public struct AssetInfoScreen: View {
    
    // MARK: Dependencies
    let asset: PHAssetDetailedModel?
    
    // MARK: Init
    public init(asset: PHAssetDetailedModel?) {
        self.asset = asset
    }
    
    // MARK: - View
    public var body: some View {
        if let asset {
            VStack(alignment: .leading, spacing: Spacing.standard) {
                LabelStructuredView(
                    title: "Device",
                    value: asset.device
                )
                
                LabelStructuredView(
                    title: "Date",
                    value: asset.date?.formatted(date: .complete, time: .shortened) ?? "-"
                )
                
                HStack(spacing: Spacing.small) {
                    LabelStructuredView(
                        title: "Dimensions",
                        value: asset.dimensions
                    )
                    
                    LabelStructuredView(
                        title: "File size",
                        value: asset.fileSize?.formatted() ?? "-" + " Mo"
                    )
                }
                
                HStack(spacing: Spacing.small) {
                    LabelStructuredView(
                        title: "Latitude",
                        value: asset.latitude?.formatted() ?? "-"
                    )
                    
                    LabelStructuredView(
                        title: "Longitude",
                        value: asset.longitude?.formatted() ?? "-"
                    )
                }
                
                if asset.coordinates != nil {
                    AssetMapCellView(asset: asset)
                }
            }
            .padding(Spacing.large)
            .background(Color.Background.bg50)
        }
    }
}

// MARK: - Preview
// #Preview {
//    AssetInfoScreen(asset: <#T##PHAssetDetailedModel#>)
// }
