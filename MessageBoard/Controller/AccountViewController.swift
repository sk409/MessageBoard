import UIKit

class AccountViewController: UIViewController {
    
    private(set) var followButton = FollowButton()
    
    private var profileView = UIView()
    private var userImageView = UIImageView(image: UIImage(named: "user_male"))
    private var userNameLabel = UILabel()
    private var messageTableView = MessageTableView()
    private var messageDatas = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessageDatas()
    }
    
    func initialize(userName: String) {
        setupProfileView()
        setupUserImageView()
        setupUserNameLabel(userName: userName)
        setupFollowButton(userName: userName)
        setupMessageTableView()
    }
    
    private func setupProfileView() {
        view.addSubview(profileView)
        profileView.layer.borderWidth = 0.5
        profileView.layer.borderColor = UIColor.lightGray.cgColor
        profileView.backgroundColor = UIColor.white
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
    }
    
    private func setupUserImageView() {
        profileView.addSubview(userImageView)
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 16).isActive = true
        userImageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        userImageView.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.4).isActive = true
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
    }
    
    private func setupUserNameLabel(userName: String) {
        profileView.addSubview(userNameLabel)
        userNameLabel.text = userName
        userNameLabel.textAlignment = .center
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    private func setupFollowButton(userName: String) {
        guard let viewerUserName = UserManager.userName else {
            return
        }
        if userName == viewerUserName {
            return
        }
        profileView.addSubview(followButton)
        followButton.initialize(userName)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        followButton.centerXAnchor.constraint(equalTo: profileView.centerXAnchor).isActive = true
        followButton.heightAnchor.constraint(equalTo: profileView.heightAnchor, multiplier: 0.15).isActive = true
        followButton.widthAnchor.constraint(equalTo: profileView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func setupMessageTableView() {
        view.addSubview(messageTableView)
        messageTableView.setMessageDataSource(self)
        messageTableView.tableFooterView = UIView()
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        messageTableView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 0).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        messageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        messageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    private func fetchMessageDatas() {
        guard let userName = userNameLabel.text else {
            return
        }
        guard let messageDatas = MessageDataCenter.fetchMessageDatas(messageUserNames: [userName]) else {
            return
        }
        self.messageDatas = messageDatas
        messageTableView.reloadData()
    }
    
}

extension AccountViewController: MessageTableViewDataSource {
    func getMessageDatas() -> [MessageData] {
        return messageDatas
    }
}
