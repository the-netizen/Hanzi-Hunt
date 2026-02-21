import Foundation

struct Vocabulary: Identifiable, Codable{
    let id: UUID
    let object: String
    let hanzi: String
    let pinyin: String
    let english: String
    var isCollected: Bool
    
    init(id: UUID = UUID(),
            hanzi: String,
            pinyin: String,
            english: String,
            object: String,
            isCollected: Bool = false) {
           self.id = id
           self.hanzi = hanzi
           self.pinyin = pinyin
           self.english = english
           self.object = object
           self.isCollected = isCollected
       }
}

extension Vocabulary {
    static let samples: [Vocabulary] = [
        Vocabulary(hanzi: "人", pinyin: "rén", english: "person, mankind", object: "person"),
        Vocabulary(hanzi: "狗", pinyin: "gǒu", english: "dog", object: "dog"),
        Vocabulary(hanzi: "猫", pinyin: "māo", english: "cat", object: "cat"),
        Vocabulary(hanzi: "书", pinyin: "shū", english: "book", object: "book"),
        Vocabulary(hanzi: "桌子", pinyin: "zhuōzi", english: "table, desk", object: "table"),
        Vocabulary(hanzi: "椅子", pinyin: "yǐzi", english: "chair", object: "chair"),
        Vocabulary(hanzi: "杯子", pinyin: "bēizi", english: "cup, glass", object: "cup"),
        Vocabulary(hanzi: "树", pinyin: "shù", english: "tree", object: "tree"),
        Vocabulary(hanzi: "车", pinyin: "chē", english: "car, vehicle", object: "car"),
        Vocabulary(hanzi: "门", pinyin: "mén", english: "door, gate", object: "door")
    ]
}
