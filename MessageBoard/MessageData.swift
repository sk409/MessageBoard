import Foundation

class MessageData: Codable {
    
    static let favoriteFlag = 1
    static let notFavoriteFlag = 0
    
    let id: Int
    let userName: String
    let contents: String
    let createdAt: String
    var favoriteCount: Int?
    var replyCount: Int?
    var isFavorite: Int
    
    func toggleFaboriteFlag() {
        if isFavorite == MessageData.favoriteFlag {
            isFavorite = MessageData.notFavoriteFlag
        } else {
            isFavorite = MessageData.favoriteFlag
        }
    }
}
