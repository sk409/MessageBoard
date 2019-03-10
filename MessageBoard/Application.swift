import UIKit

class Application {
    
    static private(set) var settings: ApplicationSettings?
    
    static func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        return controller
    }
    
    static func getRouterViewController() -> RouterViewController? {
        guard let appDelegate = UIApplication.shared.delegate else {
            return nil
        }
        guard let window = appDelegate.window else {
            return nil
        }
        guard let rooterViewController = window?.rootViewController else {
            return nil
        }
        return rooterViewController as? RouterViewController
    }
    
    static func initialize() {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = libraryURL.appendingPathComponent("Settings.json")
        guard let jsonData = try? Data(contentsOf: fileURL) else {
            return
        }
        guard let settings = try? JSONDecoder().decode(ApplicationSettings.self, from: jsonData) else {
            return
        }
        self.settings = settings
    }
    
    static func notification(on foundation: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeButton = UIAlertAction(title: "閉じる", style: .default, handler: handler)
        alert.addAction(closeButton)
        foundation.present(alert, animated: true)
    }
    
    static func notification(on foundation: UIViewController, message: String) {
        notification(on: foundation, message: message, handler: nil)
    }
    
    static func notification(on foundation: UIViewController, message: String, handler: ((UIAlertAction) -> Void)?) {
        notification(on: foundation, title: "", message: message, handler: handler)
    }
    
    static func notification(on foundation: UIViewController, title: String, message: String) {
        notification(on: foundation, title: title, message: message, handler: nil)
    }
    
    static func warning(on foundation: UIViewController, message: String, handler: ((UIAlertAction) -> Void)?) {
        notification(on: foundation, title: "警告", message: message, handler: handler)
    }
    
    static func warning(on foundation: UIViewController, message: String) {
        warning(on: foundation, message: message, handler: nil)
    }
    
    static func log(message: String, file: String = #file, function: String = #function, line: Int = #line) {
        print("*******************************************************")
        print(file + ": " + function + "(" + String(line) + ")")
        print(message)
        print("*******************************************************")
    }
    
}
