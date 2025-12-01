//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 11/11/2025.
//

import SwiftUI
import DesignSystem
import MapKit
import Models

struct AssetMapCellView: View {
    
    let asset: PHAssetDetailedModel
    
    var cameraPosition: MapCameraPosition {
        return .region(
            .init(
                center: asset.coordinates ?? .init(),
                latitudinalMeters: 400,
                longitudinalMeters: 400
            )
        )
    }
    
    // MARK: -
    var body: some View {
        Map(initialPosition: cameraPosition) {
//            Annotation(transaction.nameDisplayed, coordinate: coordinates) {
//                IconSVG(icon: systemImage, value: .standard)
//                    .foregroundStyle(Color.white)
//                    .padding(6)
//                    .background {
//                        Circle()
//                            .fill(transaction.category?.color ?? .blue)
//                    }
//            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .frame(height: 200)
        .clipShape(.rect(cornerRadius: CornerRadius.large, style: .continuous))
//        .disabled(true)
    }
}

// MARK: - Preview
// #Preview {
//    AssetMapCellView()
// }
