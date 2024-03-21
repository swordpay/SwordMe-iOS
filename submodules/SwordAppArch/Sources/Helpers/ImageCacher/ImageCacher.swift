//
//  ImageSaver.swift
//  SwordAppArch
//
//  Created by Tigran Simonyan on 07.09.23.
//

import UIKit

public final class ImageCacher {
    public var mainURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    public static let global: ImageCacher = {
        struct SingletonWrapper {
            static let singleton = ImageCacher()
        }

        return SingletonWrapper.singleton
    }()
    
    private init() {

    }
    
    @discardableResult
    public func saveImage(uiImage: UIImage, name: String, compressionQuality: CGFloat = 0.8) -> Bool {
        guard let data = uiImage.jpegData(compressionQuality: compressionQuality) else { return false }
        
        return saveImage(data: data, name: name)
    }
    
    @discardableResult
    public func saveFile(atURL: URL, name: String) -> Bool {
        guard let directory = mainURL as? NSURL else {
            return false
        }

        do {
            let url = directory.appendingPathComponent(name)!

            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            
            let _ = try FileManager.default.copyItem(at: atURL, to: url)

            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    @discardableResult
    public func saveImage(data: Data, name: String) -> Bool {
        guard let directory = mainURL as? NSURL else {
            return false
        }
        
        do {
            let url = directory.appendingPathComponent(name)!

            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            try data.write(to: url)

            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    public func copyItemToPreviewURL(from url: URL) -> URL? {
        guard let mainURL else { return nil }
        
        let destination = mainURL.appendingPathComponent("Preview.\(url.pathExtension)")
                
        do {
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            
            let _ = try FileManager.default.copyItem(at: url, to: destination)

            return destination
        } catch {
            print("Failed to provide preview url \(error.localizedDescription)")
            return nil
        }
    }
    
    public func removePreviewedItem(for url: URL) {
        guard let mainURL else { return }
        
        let destination = mainURL.appendingPathComponent("Preview.\(url.pathExtension)")
        do {
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            
            let _ = try FileManager.default.copyItem(at: url, to: destination)
        } catch {
            print("Failed to provide preview url \(error.localizedDescription)")
        }
    }

    public func provideTempFolderPath(pathExtension: String) -> URL? {
        guard let mainURL else { return nil }
        
        let tempURL = mainURL.appendingPathComponent("tempFile-\(UUID().uuidString).\(pathExtension)")
        
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }

            return tempURL
        } catch {
            print("Providing temp path failed with error \(error.localizedDescription)")
            return nil
        }
    }
    
    public func calculateFileSize(atUrl url: URL) -> Int64? {
        let fileManager = FileManager.default
        
        guard fileManager.fileExists(atPath: url.path) else {
            print("File does not exist at path: \(url.path)")

            return nil
        }
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[.size] as? NSNumber {
                
                return fileSize.int64Value
            }
        } catch {
            print("calculateFileSize error: \(error)")
        }

        return nil
    }
}

