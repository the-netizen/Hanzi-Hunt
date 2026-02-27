import Foundation
import UIKit

struct CollectedWord: Identifiable, Codable {
    let id: String
    let vocabulary: Vocabulary
    let capturedImageData: Data
    let capturedDate: Date
    
    init(vocabulary: Vocabulary, capturedImage: UIImage, capturedDate: Date) {
        self.id = UUID().uuidString
        self.vocabulary = vocabulary
        self.capturedImageData = capturedImage.jpegData(compressionQuality: 0.8) ?? Data()
        self.capturedDate = capturedDate
    }
    
    var image: UIImage? {
        UIImage(data: capturedImageData)
    }
}
