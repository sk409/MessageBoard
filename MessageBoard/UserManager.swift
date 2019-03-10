import Foundation

struct UserManager {
    
    private struct Follow: Codable {
        let userName: String
    }
    
    private struct Follower: Codable {
        let userName: String
    }
    
    static var userName: String? {
        get {
            return isLoggedIn() ? UserDefaults.standard.string(forKey: userNameKey) : nil
        }
    }
    static var userPassword: String? {
        get {
            return isLoggedIn() ? UserDefaults.standard.string(forKey: userPasswordKey) : nil
        }
    }
    
    static private let isLoggedInKey = "\(UserManager.self).isUserLoggedIn"
    static private let userNameKey = "\(UserManager.self).userName"
    static private let userPasswordKey = "\(UserManager.self).password"
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    static func login(userName: String, userPassword: String) {
        UserDefaults.standard.set(true, forKey: isLoggedInKey)
        UserDefaults.standard.set(userName, forKey: userNameKey)
        UserDefaults.standard.set(userPassword, forKey: userPassword)
    }
    
    static func logout() {
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
    
    static func exist(userName: String, userPassword: String) -> Bool {
        let functionObserver = FunctionObserver()
        guard let settings = Application.settings else {
            return false
        }
        guard let session = DatabaseSession(mediator: "check_existence_user.php", webServerHost: settings.webServerHost) else {
            return false
        }
        guard let response = session.sync(queries: settings.getQueries(merge: ["user_name": userName, "user_password": userPassword]), method: .get) else {
            return false
        }
        guard let data = response.data else {
            return false
        }
        guard let result = String(data: data, encoding: .utf8) else {
            return false
        }
        functionObserver.complete()
        return result == "true"
    }
    
    static func getFollowUserNames() -> [String] {
        let functionObserver = FunctionObserver()
        guard let settings = Application.settings else {
            return []
        }
        guard let userName = self.userName else {
            return []
        }
        guard let session = DatabaseSession(mediator: "get_follow.php", webServerHost: settings.webServerHost) else {
            return []
        }
        let queries = settings.getQueries(merge: ["user_name": userName])
        guard let response = session.sync(queries: queries, method: .get) else {
            return []
        }
        guard let data = response.data else {
            return []
        }
        guard let follows = try? JSONDecoder().decode([Follow].self, from: data) else {
            return []
        }
        var userNames = [String]()
        userNames.reserveCapacity(follows.count)
        for follower in follows {
            userNames.append(follower.userName)
        }
        functionObserver.complete()
        return userNames
    }
    
    static func getFollowerUseNames() -> [String] {
        let functionObserver = FunctionObserver()
        guard let settings = Application.settings else {
            return []
        }
        guard let userName = self.userName else {
            return []
        }
        guard let session = DatabaseSession(mediator: "get_follower.php", webServerHost: settings.webServerHost) else {
            return []
        }
        let queries = settings.getQueries(merge: ["user_name": userName])
        guard let response = session.sync(queries: queries, method: .get) else {
            return []
        }
        guard let data = response.data else {
            return []
        }
        guard let followers = try? JSONDecoder().decode([Follower].self, from: data) else {
            return []
        }
        var userNames = [String]()
        userNames.reserveCapacity(followers.count)
        for follower in followers {
            userNames.append(follower.userName)
        }
        functionObserver.complete()
        return userNames
    }
    
    private init() {}
    
}
