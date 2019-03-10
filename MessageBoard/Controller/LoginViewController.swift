import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        let functionObserver = FunctionObserver() {
            Application.warning(on: self, message: "ログインに失敗しました")
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
        guard UserManager.exist(userName: userName, userPassword: userPassword) else {
            Application.warning(on: self, message: "ユーザ名・パスワードの組みが正しくありません")
            return
        }
        UserManager.login(userName: userName, userPassword: userPassword)
        Application.notification(on: self, message: "ログインに成功しました") { _ in
            guard let routerViewController = Application.getRouterViewController() else {
                return
            }
            let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            routerViewController.reset(to: mainTabBarController)
        }
        functionObserver.complete()
    }
    
    
    @IBAction func resetToSignUpViewController(_ sender: Any) {
        guard let rooterViewController = Application.getRouterViewController() else {
            return
        }
        let signUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController")
        rooterViewController.reset(to: signUpViewController)
    }
}
