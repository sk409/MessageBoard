import UIKit

class RelationshipViewController: UIViewController {
    
    enum Mode {
        case follow
        case follower
    }

    @IBOutlet weak var userTableView: UserTableView!
    
    private var mode = Mode.follow
    private var relatedUserNames = [String]()
    private var displayedUserNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.setUserTableViewDataSource(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRelatedUserNames()
    }
    
    private func fetchRelatedUserNames() {
        switch mode {
        case .follow:
            relatedUserNames = UserManager.getFollowUserNames()
            displayedUserNames = relatedUserNames
        case .follower:
            relatedUserNames = UserManager.getFollowerUseNames()
            displayedUserNames = relatedUserNames
        }
        userTableView.reloadData()
    }

}

extension RelationshipViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            displayedUserNames = relatedUserNames
            return
        }
        displayedUserNames = relatedUserNames.filter {relatedUserName in
            return relatedUserName.lowercased().contains(searchText.lowercased())
        }
        userTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == 0 {
            mode = .follow
        } else {
            mode = .follower
        }
        fetchRelatedUserNames()
    }
    
}

extension RelationshipViewController: UserTableViewDataSource {
    func getUserNames() -> [String] {
        return displayedUserNames
    }
}
