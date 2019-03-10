import Foundation

class MessageDataCenter {
    
    static func fetchMessageDatas(messageUserNames: [String]) -> [MessageData]? {
        let functionObserber = FunctionObserver()
        guard let viewerUserName = UserManager.userName else {
            return nil
        }
        guard let settings = Application.settings else {
            return nil
        }
        guard let session = DatabaseSession(mediator: "get_message_data.php", webServerHost: settings.webServerHost) else {
            return nil
        }
        let query = URLQueryObject()
        query.addQueries(queries: settings.getQueries())
        query.addArray(name: "message_user_names[]", values: messageUserNames)
        query.addValue(name: "viewer_user_name", value: viewerUserName)
        guard let response = session.sync(query: query, method: .get) else {
            return nil
        }
        guard let data = response.data else {
            return nil
        }
        //print(String(data: data, encoding: .utf8))
        guard let messageDatas = try? JSONDecoder().decode([MessageData].self, from: data) else {
            return nil
        }
        functionObserber.complete()
        return messageDatas
    }
    
    static func postMessage(userName: String, id: Int, contents: String) -> Bool {
        guard let settings = Application.settings else {
            return false
        }
        guard let session = DatabaseSession(mediator: "insert_message.php", webServerHost: settings.webServerHost) else {
            return false
        }
        let queries = settings.getQueries(merge: ["user_name": userName, "message_id": String(id), "message_contents": contents])
        guard let response = session.sync(queries: queries, method: .post) else {
            return false
        }
        guard let data = response.data else {
            return false
        }
        guard let result = String(data: data, encoding: .utf8) else {
            return false
        }
        guard result == "OK" else {
            return false
        }
        return true
    }
    
    private init() {}
}
