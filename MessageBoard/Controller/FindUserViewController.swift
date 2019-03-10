import UIKit

class FindUserViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UserTableView!
    
    private var userNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.setUserTableViewDataSource(self)
    }
    
    @IBAction func goBackToPreviousViewController(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension FindUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            return
        }
        guard let settings = Application.settings else {
            return
        }
        let queries = settings.getQueries(merge: ["user_name": searchText])
        guard let session = DatabaseSession(mediator: "get_user.php", webServerHost: settings.webServerHost) else {
            return
        }
        guard let response = session.sync(queries: queries, method: .get) else {
            return
        }
        guard let data = response.data else {
            return
        }
        guard let userNames = try? JSONDecoder().decode([String].self, from: data) else {
            return
        }
        self.userNames = userNames
        userTableView.reloadData()
    }
    
}

extension FindUserViewController: UserTableViewDataSource {
    func getUserNames() -> [String] {
        return userNames
    }
}
