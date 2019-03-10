import Foundation

struct DatabaseSession {
    
    struct Response {
        
        let data: Data?
        let response: URLResponse?
        let error: Error?
        
        init(data: Data?, response: URLResponse?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
    }
    
    var urlComponents: URLComponents?
    
    init?(mediator: String, webServerHost: String) {
        let urlString = "http://" + webServerHost + "/" + mediator
        guard let urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        self.urlComponents = urlComponents
    }
    
    func sync(queries: [String: String], method: HTTPMethod) -> Response? {
        var result: Response?
        let semaphore = DispatchSemaphore(value: 0)
        async(queries: queries, method: method) { data, response, error in
            result = Response(data: data, response: response, error: error)
            semaphore.signal()
        }
        semaphore.wait()
        return result!
    }
    
    func sync(query: URLQueryObject, method: HTTPMethod) -> Response? {
        var result: Response?
        let semaphore = DispatchSemaphore(value: 0)
        async(query: query, method: method) { data, response, error in
            result = Response(data: data, response: response, error: error)
            semaphore.signal()
        }
        semaphore.wait()
        return result!
    }
    
    func async(queries: [String: String], method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        switch method {
        case .get:
            guard let urlString = getURLString(queries: queries) else {
                return
            }
            guard let url = URL(string: urlString) else {
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
        case .post:
            guard let request = getURLRequest(queries: queries) else {
                return
            }
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    func async(query: URLQueryObject, method: HTTPMethod, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        switch method {
        case .get:
            guard let urlString = getURLString(query: query) else {
                return
            }
            guard let url = URL(string: urlString) else {
                return
            }
            URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
        case .post:
            guard let request = getURLRequest(query: query) else {
                return
            }
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    private func getURLRequest(queries: [String: String]) -> URLRequest? {
        guard var urlComponents = self.urlComponents else {
            return nil
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlComponents.queryItems = queries.map { URLQueryItem(name: $0, value: $1) }
        guard let query = urlComponents.query else {
            return nil
        }
        urlRequest.httpBody = query.data(using: .utf8)
        return urlRequest
    }
    
    private func getURLRequest(query: URLQueryObject) -> URLRequest? {
        guard var urlComponents = self.urlComponents else {
            return nil
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlComponents.queryItems = query.items
        guard let query = urlComponents.query else {
            return nil
        }
        urlRequest.httpBody = query.data(using: .utf8)
        return urlRequest
    }
    
    private func getURLString(queries: [String: String]) -> String? {
        var queryItems = [URLQueryItem]()
        for (name, value) in queries {
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        guard var urlComponents = self.urlComponents else {
            return nil
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            return nil
        }
        return url.absoluteString
    }
    
    private func getURLString(query: URLQueryObject) -> String? {
        guard var urlComponents = self.urlComponents else {
            return nil
        }
        urlComponents.queryItems = query.items
        guard let url = urlComponents.url else {
            return nil
        }
        return url.absoluteString
    }
    
}
