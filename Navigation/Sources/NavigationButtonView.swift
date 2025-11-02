//
//  NavigationButtonView.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import NavigationKit

public struct NavigationButtonView<Label: View>: View {

    // MARK: Dependencies
    let route: Route
    let destination: AppDestination
    let onDismiss: (() -> Void)?
    let onNavigate: (() -> Void)?
    let withZoomTransition: Bool
    let label: () -> Label

    // MARK: Init
    public init(
        route: Route,
        destination: AppDestination,
        onDismiss: (() -> Void)? = nil,
        onNavigate: (() -> Void)? = nil,
        withZoomTransition: Bool = false,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.route = route
        self.destination = destination
        self.onDismiss = onDismiss
        self.onNavigate = onNavigate
        self.withZoomTransition = withZoomTransition
        self.label = label
    }

    // MARK: -
    public var body: some View {
        GenericNavigationButton(
            route: route,
            destination: destination,
            onDismiss: onDismiss,
            onNavigate: onNavigate,
            withZoomTransition: withZoomTransition,
            label: { label() }
        )
    }
}
