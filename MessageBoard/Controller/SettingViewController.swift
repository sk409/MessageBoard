import UIKit

class SettingViewController: UIViewController {
    
    static private let numberOfSettingItems = 7
    
    @IBOutlet weak var tableView: UITableView!
    
    private var queries = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tableView.tableFooterView = UIView()
    }

    @IBAction func saveSettings(_ sender: Any) {
        let functionObserber = FunctionObserver() {
            Application.warning(on: self, message: "アプリケーションの設定に失敗しました")
        }
        guard let webServerHost = queries["web_server_host"] else {
            return
        }
        queries.removeValue(forKey: "web_server_host")
        guard let session = DatabaseSession(mediator: "initialize.php", webServerHost: webServerHost) else {
            return
        }
        guard let response = session.sync(queries: queries, method: .post) else {
            return
        }
        guard let data = response.data else {
            return
        }
        guard let text = String(data: data, encoding: .utf8) else {
            return
        }
        guard text == "OK" else {
            return
        }
        let settings = [
            "appAdminUserName": queries["app_admin_user_name"],
            "appAdminUserPassword": queries["app_admin_user_password"],
            "appDatabaseName": queries["app_database_name"],
            "databaseServerHost": queries["database_server_host"],
            "webServerHost": webServerHost
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: settings, options: []) else {
            return
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = libraryURL.appendingPathComponent("Settings.json")
        do {
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            Application.log(message: error.localizedDescription)
        }
        Application.initialize()
        Application.notification(on: self, title: "", message: "設定を保存しました")
        functionObserber.complete()
    }
    
    
    @IBAction func resetToEntranceViewController(_ sender: Any) {
        guard let routerViewController = Application.getRouterViewController() else {
            return
        }
        routerViewController.reset(to: EntranceViewController())
    }
    
    func settingContentsChanged(settingItemaName: String, settingContents: String) {
        queries[settingItemaName] = settingContents
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingViewController.numberOfSettingItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemNames = ["MySQLユーザ名", "MySQLパスワード", "Webサーバホスト", "データベースサーバホスト", "アプリ管理ユーザ名", "アプリ管理ユーザパスワード", "アプリデータベース名"]
        let queryParameterNames = ["mysql_user_name", "mysql_user_password", "web_server_host", "database_server_host", "app_admin_user_name", "app_admin_user_password", "app_database_name"]
        let itemName = itemNames[indexPath.row]
        let queryParameterName = queryParameterNames[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.setData(itemName: itemName, queryParameterName: queryParameterName, notification: settingContentsChanged)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
