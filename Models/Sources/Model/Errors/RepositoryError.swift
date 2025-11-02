//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import Foundation

public enum RepositoryError: Error {
    case notFound
    case invalidData
    case saveFailed(Error)
}
