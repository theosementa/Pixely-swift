//
//  ContentEditInputRequest.swift
//  Models
//
//  Created by Theo Sementa on 02/11/2025.
//

import SwiftUI
import Photos

public struct ContentEditInputRequest {
    public var requestId: PHContentEditingInputRequestID?
    public var contentEditingInput: PHContentEditingInput
    
    public init(
        requestId: PHContentEditingInputRequestID? = nil,
        contentEditingInput: PHContentEditingInput
    ) {
        self.requestId = requestId
        self.contentEditingInput = contentEditingInput
    }
}
