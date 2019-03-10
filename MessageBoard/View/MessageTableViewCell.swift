import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    
    private var messageData: MessageData?
    private var reloadTable: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        guard let settings = Application.settings else {
            return
        }
        guard let userName = UserManager.userName else {
            return
        }
        guard let messageData = self.messageData else {
            return
        }
        let queries = settings.getQueries(merge: ["user_name": userName, "message_user_name": messageData.userName, "message_id": String(messageData.id)])
        guard let session = messageData.isFavorite == MessageData.favoriteFlag ? DatabaseSession(mediator: "delete_favorite.php", webServerHost: settings.webServerHost) : DatabaseSession(mediator: "insert_favorite.php", webServerHost: settings.webServerHost) else {
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
        messageData.toggleFaboriteFlag()
        if messageData.favoriteCount == nil {
            messageData.favoriteCount = 1
        } else {
            if messageData.isFavorite == MessageData.favoriteFlag {
                messageData.favoriteCount! += 1
            } else {
                messageData.favoriteCount! -= 1
                if messageData.favoriteCount! == 0 {
                    messageData.favoriteCount = nil
                }
            }
        }
        guard let reloadTable = self.reloadTable else {
            return
        }
        reloadTable()
    }
    
    @IBAction func replayButtonTapped(_ sender: Any) {
        guard let topViewController = Application.getTopViewController() else {
            return
        }
        let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        postViewController.setDelegate(self)
        topViewController.present(postViewController, animated: true)
    }
    
    
    func setData(messageData: MessageData, reloadTable: @escaping () -> Void) {
        userNameLabel.text = messageData.userName
        messageLabel.text = messageData.contents
        dateTimeLabel.text = messageData.createdAt
        favoriteCountLabel.text = messageData.favoriteCount == nil ? nil : String(messageData.favoriteCount!)
        replyCountLabel.text = messageData.replyCount == nil ? nil : String(messageData.replyCount!)
        self.messageData = messageData
        self.reloadTable = reloadTable
        if messageData.isFavorite == MessageData.favoriteFlag {
            favoriteButton.setImage(UIImage(named: "like_exist"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like_none"), for: .normal)
        }
    }
    
    private func initialize() {
        setupUserImage()
        setupUserNameLabel()
    }
    
    private func setupUserImage() {
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setupUserNameLabel() {
//        let gestureRecpgnizer = UIGestureRecognizer(target: self, action: <#T##Selector?#>)
//        userNameLabel.isUserInteractionEnabled = true
    }
    
    private func transitToAccountViewController() {
        
    }
    
}

extension MessageTableViewCell: PostViewControllerDelegate {
    
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
        guard let settings = Application.settings else {
            return false
        }
        guard let messageData = self.messageData else {
            return false
        }
        let queries = settings.getQueries(merge: ["source_message_user_name": userName, "source_message_id": String(messageID), "dest_message_user_name": messageData.userName, "dest_message_id": String(messageData.id)])
        guard let session = DatabaseSession(mediator: "insert_reply.php", webServerHost: settings.webServerHost) else {
            return false
        }
        guard let response = session.sync(queries: queries, method: .post) else {
            return false
        }
        guard let data = response.data else {
            return false
        }
        guard let result = String(data: data, encoding: .utf8) else {
            return false
        }
        guard result == "OK" else {
            return false
        }
        return true
    }
    
}
