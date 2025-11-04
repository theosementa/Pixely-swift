//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos
import Models

@Observable @MainActor
public final class AssetManager: NSObject {
    
    @MainActor let photoLibrary = PHPhotoLibrary.shared()
    
    public var photoAssetCollection: AssetCollection = AssetCollection(PHFetchResult<PHAsset>())
    let cacheManager = CachedImageManager()
    
    // MARK: Init
    public override init() {
        super.init()
        Task {
            guard await checkAuthorization() else { return }
            PHPhotoLibrary.shared().register(self)
            refreshPhotoAssets()
        }
    }

}

extension AssetManager {
    
    private func checkAuthorization() async -> Bool {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:       return true
        case .notDetermined:    return await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
        case .denied:           return false
        case .limited:          return false
        case .restricted:       return false
        @unknown default:       return false
        }
    }
    
}

extension AssetManager {
    
    @MainActor // TODO: Voir si pas de lag
    private func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) {
        let newFetchResult = fetchResult ?? {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            return PHAsset.fetchAssets(with: fetchOptions)
        }()
        
        self.photoAssetCollection = AssetCollection(newFetchResult)
    }
    
    func setIsFavorite(for asset: PHAsset, _ isFavorite: Bool) async throws {
        if !asset.canPerform(.properties) {
            print("not able to edit asset property")
            throw AssetError.failed
        }
        
        do {
            try await photoLibrary.performChanges { @Sendable in
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = isFavorite
            }
        } catch {
            print("Failed to change isFavorite: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
    func createAsset(data: Data, type: PHAssetResourceType) async throws {
        do {
            try await photoLibrary.performChanges { @Sendable in
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: type, data: data, options: nil)
            }
        } catch {
            print("Failed to create asset: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
    func createAsset(asset: AVAsset?) async throws {
        guard let asset, let urlAsset = asset as? AVURLAsset else { throw AssetError.failed }
        
        do {
            try await photoLibrary.performChanges { @Sendable in
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: urlAsset.url, options: nil)
            }
        } catch {
            print("Failed to create asset: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
    func deleteAsset(_ asset: PHAsset) async throws {
        if !asset.canPerform(.delete) {
            print("not able to delete asset")
            throw AssetError.failed
        }
        
        do {
            try await photoLibrary.performChanges { @Sendable in
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }
            print("PhotoAsset asset deleted")
        } catch {
            print("Failed to delete photo: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
}

// MARK: - Editing
extension AssetManager {
    
    // image editing
    func requestContentEditingInput(for phAsset: PHAsset) async throws -> ContentEditInputRequest {
        let option = PHContentEditingInputRequestOptions()
        option.canHandleAdjustmentData = { _ in
            // true for enabling rolling back to a previous version made elsewhere
//            return true
            return false
        }
        var requestId: PHContentEditingInputRequestID?
        
        let contentEditInfo: ContentEditWithInfoModel = await withCheckedContinuation { continuation in
            var nillableContinuation: CheckedContinuation<ContentEditWithInfoModel, Never>? = continuation

            requestId = phAsset.requestContentEditingInput(with: option) { contentEditingInput, info in
                nillableContinuation?.resume(returning: .init(content: contentEditingInput, info: info))
                nillableContinuation = nil
            }
        }
        
        if let error = contentEditInfo.info?[PHContentEditingInputErrorKey] as? Error {
            print("PhotoLibraryError request edit error: \(error.localizedDescription)")
            throw AssetError.error(error)
        } else if let cancelled = (contentEditInfo.info?[PHContentEditingInputCancelledKey] as? NSNumber)?.boolValue, cancelled {
            print("PhotoLibraryError request canceled")
            throw AssetError.cancelled
        }
        
        if let contentEditingInput = contentEditInfo.content {
            return ContentEditInputRequest(
                requestId: requestId,
                contentEditingInput: contentEditingInput
            )
        } else {
            throw AssetError.failed
        }
    }
    
    func saveEditContent(
        for asset: PHAsset,
        contentEditingInput: PHContentEditingInput,
        with adjustment: PHAdjustmentData
    ) async throws {
        let editingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput)
        editingOutput.adjustmentData = adjustment
        
        do {
            let url = editingOutput.renderedContentURL
            let data = adjustment.data
            try data.write(to: url)

            try await photoLibrary.performChanges { @Sendable in
                let request = PHAssetChangeRequest(for: asset)
                request.contentEditingOutput = editingOutput
            }
                        
        } catch {
            print("Failed to create asset: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
}

// MARK: - Observer
extension AssetManager: @preconcurrency PHPhotoLibraryChangeObserver {
    
    @MainActor // TODO: Voir si pas de lag
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: self.photoAssetCollection.fetchResult) else { return }
        self.refreshPhotoAssets(changes.fetchResultAfterChanges)
    }
    
}
