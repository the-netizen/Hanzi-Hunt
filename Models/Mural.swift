import Foundation


struct Mural: Identifiable, Codable{
    let id: UUID
    let title: String
    let imageName: String
    let objects: [String] //cant we use names instead of UUID here?
    
    //why init it?
    init(id: UUID = UUID(),
             title: String,
             imageName: String,
             objects: [String]) {
            self.id = id
            self.title = title
            self.imageName = imageName
            self.objects = objects
        }
    
    func collectionProgress(vocabulary: [Vocabulary]) -> (collected: Int, total: Int){
        let muralWords = vocabulary.filter { objects.contains($0.object) }
        let collected = muralWords.filter { $0.isCollected }.count
        return (collected, muralWords.count)
    }
    
//    func getVocabulary
}

extension Mural {
    static let samples: [Mural] = [
        Mural(
            title: "Road side",
            imageName: "mural1",
            objects:["tree", "road", "bird", "person"]
            
        ),
        Mural(
            title: "Study Desk",
            imageName: "mural2",
            objects: ["laptop" , "pen", "book", "phone"]
        ),
        Mural(
            title: "Park",
            imageName: "mural3",
            objects: ["tree", "dog", "bench", "flower"]
        ),
        Mural(
            title: "Kitchen",
            imageName: "mural4",
            objects: ["bowl", "cup", "refrigerator", "spoon"]
        ),
        Mural(
            title: "Classroom",
            imageName: "mural5",
            objects: ["blackboard", "schoolbag", "table", "chair"]
        )
    ]
}
