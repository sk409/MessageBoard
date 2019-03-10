import Foundation

class URLQueryObject {
    
    private(set) var items = [URLQueryItem]()
    
    func addValue(name: String, value: String) {
        items.append(URLQueryItem(name: name, value: value))
    }
    
    func addQueries(queries: [String: String]) {
        for (name, value) in queries {
            addValue(name: name, value: value)
        }
    }
    
    func addArray(name: String, values: [String]) {
        for value in values {
            addValue(name: name, value: value)
        }
    }
    
    func reserveCapacity(_ n: Int) {
        items.reserveCapacity(n)
    }
    
}



