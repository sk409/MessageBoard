import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let accountViewController = children.first as? AccountViewController else {
            return
        }
        guard let userName = UserManager.userName else {
            return
        }
        accountViewController.initialize(userName: userName)
    }
    
    @IBAction private func transitToPostViewController() {
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        postViewController.setDelegate(self)
        present(postViewController, animated: true)
    }
    
    @IBAction private func transitToFindUserController() {
        let findUserViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FindUserViewController") as! FindUserViewController
        present(findUserViewController, animated: true)
    }
    
    @IBAction private func logout() {
        guard let router = Application.getRouterViewController() else {
            return
        }
        UserManager.logout()
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        router.reset(to: loginViewController)
    }
}

extension HomeViewController: PostViewControllerDelegate {
    
    func postMessage(contents: String) -> Bool {
        guard !contents.isEmpty else {
            return false
        }
        guard let userName = UserManager.userName else {
            return false
        }
        let messageID = MessageIndexer.next()
        let succeeded = MessageDataCenter.postMessage(userName: userName, id: messageID, contents: contents)
        guard succeeded else {
            return false
        }
        return true
    }
    
}
