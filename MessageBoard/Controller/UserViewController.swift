import UIKit

class UserViewController: UIViewController {

    private var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let accountViewController = children.first as? AccountViewController else {
            return
        }
        accountViewController.initialize(userName: userName)
    }

    @IBAction func goBackToPreviousViewController(_ sender: Any) {
        dismiss(animated: true)
    }

    func setUserName(_ userName: String) {
        self.userName = userName
    }
}
