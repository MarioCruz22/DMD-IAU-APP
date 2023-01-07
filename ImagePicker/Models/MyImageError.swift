//
//  MyImageError.swift
//  login
//
//  Created by pedro on 12/30/22.
//

import SwiftUI

enum MyImageError: Error, LocalizedError {
    case readError
    case decodingError
    case encodingError
    case saveError
    case saveImageError
    case readImageError
    
    var errorDescription: String? {
        switch self {
        case .readError:
            return NSLocalizedString("Could not load MyImage.json, please reinstall the app.", comment: "")
        case .decodingError:
            return NSLocalizedString("there was a problem loading your list of images, please create a new image to start over.", comment: "")
        case .encodingError:
            return NSLocalizedString("Could not save your MyImage data, please reinstall the app.", comment: "")
        case .saveError:
            return NSLocalizedString("Could not save the MyImage json file. Please reinstall the app", comment: "")
        case .saveImageError:
            return NSLocalizedString("Could not save image, please reinstall app", comment: "")
        case .readImageError:
            return NSLocalizedString("Could not load image. Please reinstall the app", comment: "")
        }
    }
    
    struct ErrorType: Identifiable {
        var id = UUID()
        var error: MyImageError
        var message: String {
            error.localizedDescription
        }
        let button = Button("OK", role: .cancel) {}
    }
}
