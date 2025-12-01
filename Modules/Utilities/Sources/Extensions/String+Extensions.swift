//
//  File.swift
//  Extensions
//
//  Created by Theo Sementa on 05/11/2025.
//

import Foundation

public extension String {
    
    func removeAllBefore(_ delimiter: String) -> String {
        guard let range = self.range(of: delimiter) else {
            return self
        }
        return String(self[range.lowerBound...])
    }
    
    func exifToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        formatter.timeZone = .current
        return formatter.date(from: self)
    }
    
}
