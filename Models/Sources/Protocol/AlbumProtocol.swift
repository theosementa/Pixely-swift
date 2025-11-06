//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 06/11/2025.
//

import Foundation
import SwiftUI

public protocol AlbumProtocol: Identifiable, Hashable {
    var id: UUID { get set }
    var name: String { get set }
    var emoji: String { get set }
    var color: Color { get set }
}
