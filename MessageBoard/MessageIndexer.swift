import Foundation

class MessageIndexer {
    
    static func next() -> Int {
        let currentMessageIndexKey = "\(MessageIndexer.self).currentMessageIndex"
        if UserDefaults.standard.object(forKey: currentMessageIndexKey) == nil {
            UserDefaults.standard.set(0, forKey: currentMessageIndexKey)
        }
        let next = UserDefaults.standard.integer(forKey: currentMessageIndexKey)
        UserDefaults.standard.set(next + 1, forKey: currentMessageIndexKey)
        return next
    }
    
}
