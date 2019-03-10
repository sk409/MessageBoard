import UIKit

class EntranceViewController: UIViewController {
    
    private let startButton = UIButton()
    private let settingButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStartButton()
        setupSettingButton()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        startButton.backgroundColor = UIColor.aqua
        startButton.setTitle("START", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.addTarget(self, action: #selector(startApplication), for: .touchUpInside)
    }
    
    private func setupSettingButton() {
        view.addSubview(settingButton)
        settingButton.backgroundColor = UIColor.aqua
        settingButton.setTitle("SET UP", for: .normal)
        settingButton.setTitleColor(UIColor.white, for: .normal)
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        settingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        settingButton.addTarget(self, action: #selector(transitToSettingViewController), for: .touchUpInside)
    }
    
    @objc private func startApplication() {
        guard let routerViewController = Application.getRouterViewController() else {
            return
        }
        if UserManager.isLoggedIn() {
            let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController")
            routerViewController.reset(to: mainTabBarController)
        } else {
            let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            routerViewController.reset(to: loginViewController)
        }
    }
    
    @objc private func transitToSettingViewController() {
        guard let rooterViewController = Application.getRouterViewController() else {
            return
        }
        let settingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
        rooterViewController.reset(to: settingViewController)
    }
    
    
    
}
