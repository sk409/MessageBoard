import UIKit

protocol UserTableViewDataSource {
    func getUserNames() -> [String]
}

class UserTableView: UITableView {
    
    private var userTableViewDataSource: UserTableViewDataSource?
    
    override func awakeFromNib() {
        initialize()
    }
    
    func setUserTableViewDataSource(_ userTableViewDataSource: UserTableViewDataSource) {
        self.userTableViewDataSource = userTableViewDataSource
    }
    
    private func initialize() {
        delegate = self
        dataSource = self
        register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
}

extension UserTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userTableViewDataSource = self.userTableViewDataSource else {
            return 0
        }
        return userTableViewDataSource.getUserNames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userTableViewDataSource = self.userTableViewDataSource else {
            return UITableViewCell()
        }
        let userNames = userTableViewDataSource.getUserNames()
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.setData(userName: userNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topViewController = Application.getTopViewController() else {
            return
        }
        guard let userTableViewDataSource = self.userTableViewDataSource else {
            return
        }
        let userNames = userTableViewDataSource.getUserNames()
        let userName = userNames[indexPath.row]
        let userViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
        userViewController.setUserName(userName)
        topViewController.present(userViewController, animated: true)
    }
    
}
