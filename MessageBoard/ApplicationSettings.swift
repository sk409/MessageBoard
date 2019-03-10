import Foundation

struct ApplicationSettings: Codable {
    
    let appAdminUserName: String
    let appAdminUserPassword: String
    let appDatabaseName: String
    let databaseServerHost: String
    let webServerHost: String
    
    func getQueries() -> [String: String] {
        return [
            "app_admin_user_name": appAdminUserName,
            "app_admin_user_password": appAdminUserPassword,
            "app_database_name": appDatabaseName,
            "database_server_host": databaseServerHost,
        ]
    }
    
    func getQueries(merge: [String: String]) -> [String: String] {
        let queries = getQueries()
        return queries.merging(merge, uniquingKeysWith: { (old, new) in new })
    }
    
}
