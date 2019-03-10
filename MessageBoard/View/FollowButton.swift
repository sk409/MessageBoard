import UIKit


class FollowButton: UIButton {
    
    enum Method {
        case add
        case remove
    }
    
    private(set) var method = Method.add
    private var userName = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(onTapped), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(onTapped), for: UIControl.Event.touchUpInside)
    }
    
    func changeMethod(_ method: Method) {
        switch method {
        case .add:
            setTitle("フォロー", for: .normal)
            backgroundColor = UIColor.aqua
        case .remove:
            setTitle("フォロー解除", for: .normal)
            backgroundColor = UIColor.gray
        }
        self.method = method
    }
    
    func initialize(_ userName: String) {
        self.userName = userName
        let followUserNames = UserManager.getFollowUserNames()
        let method = followUserNames.contains(userName) ? Method.remove : Method.add
        changeMethod(method)
    }
    
    @objc private func onTapped() {
        guard !userName.isEmpty else {
            return
        }
        guard let settings = Application.settings else {
            return
        }
        guard let viewerUserName = UserManager.userName else {
            return
        }
        let queries = settings.getQueries(merge: ["following_user_name": viewerUserName, "followed_user_name": userName])
        let mediator = method == .add ? "insert_follow.php" : "delete_follow.php";
        guard let session = DatabaseSession(mediator: mediator, webServerHost: settings.webServerHost) else {
            return
        }
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
        guard let topViewController = Application.getTopViewController() else {
            return
        }
        let notificationMessage = method == .add ? "フォローしました" : "フォローを解除しました"
        Application.notification(on: topViewController, message: notificationMessage)
        changeMethod(method == .add ? .remove : .add)
    }
    
}
