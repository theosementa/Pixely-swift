//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation
import NavigationKit

public enum AppDestination: AppDestinationProtocol {
    case album(AlbumDestination)
}
