//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 02/11/2025.
//

import Photos
import Models
import Dependencies

@Observable
public final class AssetManager: NSObject, @unchecked Sendable {
    
    private let photoLibrary = PHPhotoLibrary.shared()
    let cacheManager = CachedImageManager()
    
    @ObservationIgnored
    @Dependency(\.assetDetailedStore) private var assetDetailedStore
    
    public private(set) var photoAssetCollection: AssetCollection = AssetCollection(PHFetchResult<PHAsset>())
    public private(set) var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    public var allAssets: [PHAsset] = []
    public var assetsWithoutAlbums: [PHAsset] = []
    
    public var hasAlbumsDisplayed: Bool = true
    
    public var isAuthorized: Bool {
           authorizationStatus == .authorized
       }
    
    // MARK: Init
    public override init() {
        super.init()
        checkAuthorizationStatus()
        
        if isAuthorized {
            setupPhotoLibraryObserver()
            refreshPhotoAssets()
        }
    }
    
    deinit {
        if isAuthorized {
            photoLibrary.unregisterChangeObserver(self)
        }
    }

}

// MARK: - Authorization
extension AssetManager {
    
    private func checkAuthorizationStatus() {
        authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    public func askForAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
    }
    
    private func setupPhotoLibraryObserver() {
        photoLibrary.register(self)
    }
    
}

// MARK: - Fetching Assets
public extension AssetManager {
    
    private func refreshPhotoAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        photoAssetCollection = AssetCollection(fetchResult)
        
        Task { @MainActor in
            allAssets = photoAssetCollection.asArray
            refreshFilteredCollections()
        }
    }
    
}

public extension AssetManager {
    
    @MainActor
    func refreshFilteredCollections() {
        assetsWithoutAlbums = allAssets
            .filter { assetDetailedStore.findOneBy($0.id)?.album == nil }
    }
    
}

// MARK: - Asset Operations
extension AssetManager {
    
    func setIsFavorite(for asset: PHAsset, _ isFavorite: Bool) async {
        if !asset.canPerform(.properties) {
            print("not able to edit asset property")
        }
        
        do {
            try await photoLibrary.performChanges {
                let request = PHAssetChangeRequest(for: asset)
                request.isFavorite = isFavorite
            }
        } catch {
            print("Failed to change isFavorite: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createAsset(data: Data, type: PHAssetResourceType) async throws {
        do {
            try await photoLibrary.performChanges {
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
            try await photoLibrary.performChanges {
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .video, fileURL: urlAsset.url, options: nil)
            }
        } catch {
            print("Failed to create asset: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
    func deleteAsset(_ asset: PHAsset) async {
        if !asset.canPerform(.delete) {
            print("not able to delete asset")
        }
        
        do {
            try await photoLibrary.performChanges {
                PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            }
            print("PhotoAsset asset deleted")
        } catch {
            print("Failed to delete photo: \(error.localizedDescription)")
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

            try await photoLibrary.performChanges {
                let request = PHAssetChangeRequest(for: asset)
                request.contentEditingOutput = editingOutput
            }
                        
        } catch {
            print("Failed to create asset: \(error.localizedDescription)")
            throw AssetError.failed
        }
    }
    
}

// MARK: - Photo Library Observer
extension AssetManager: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: photoAssetCollection.fetchResult)
        else { return }
        
        let newFetch = changes.fetchResultAfterChanges
        
        Task { @MainActor in
            self.photoAssetCollection = .init(newFetch)
            self.refreshPhotoAssets()
        }
    }
    
}

// MARK: - Dependencies
struct AssetManagerKey: DependencyKey {
    public static let liveValue: AssetManager = .init()
}

extension DependencyValues {
    public var assetManager: AssetManager {
        get { self[AssetManagerKey.self] }
        set { self[AssetManagerKey.self] = newValue }
    }
}
