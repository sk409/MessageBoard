import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signup(_ sender: Any) {
        let functionObserver = FunctionObserver() {
            Application.warning(on: self, message: "ユーザ登録に失敗しました")
        }
        guard let userName = self.userName.text else {
            return
        }
        guard let userPassword = self.password.text else {
            return
        }
        guard !userName.isEmpty else {
            Application.warning(on: self, message: "ユーザ名を入力してください")
            return
        }
        guard !userPassword.isEmpty else {
            Application.warning(on: self, message: "パスワードを入力してください")
            return
        }
        guard let settings = Application.settings else {
            return
        }
        guard let session = DatabaseSession(mediator: "insert_user.php", webServerHost: settings.webServerHost) else {
            return
        }
        let queries = settings.getQueries(merge: ["user_name": userName, "user_password": userPassword])
        guard let response = session.sync(queries: queries, method: .post) else {
            return
        }
        guard let data = response.data else {
            return
        }
        guard let result = String(data: data, encoding: .utf8) else {
            return
        }
        guard result == "OK" else {
            return
        }
        UserManager.login(userName: userName, userPassword: userPassword)
        Application.notification(on: self, title: "", message: "ユーザ情報を登録しました") { _ in
            guard let routerViewController = Application.getRouterViewController() else {
                return
            }
            let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            routerViewController.reset(to: mainTabBarController)
        }
        functionObserver.complete()
    }
    
    
    @IBAction func resetToLoginViewController(_ sender: Any) {
        guard let rooterViewController = Application.getRouterViewController() else {
            return
        }
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        rooterViewController.reset(to: loginViewController)
    }
    
}

