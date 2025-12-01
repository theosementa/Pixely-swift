//
//  CachedImageError.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation

public enum CachedImageError: Error {
    case error(Error)
    case cancelled
    case failed
}
