import UIKit

class PostedMessagesViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: MessageTableView!
    
    private var messageDatas = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.setMessageDataSource(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMessageDatas()
    }
    
    private func fetchMessageDatas() {
        guard let userName = UserManager.userName else {
            return
        }
        let followUserNames = UserManager.getFollowUserNames()
        guard let messageDatas = MessageDataCenter.fetchMessageDatas(messageUserNames: [userName] + followUserNames) else {
            return
        }
        self.messageDatas = messageDatas
        messageTableView.reloadData()
    }

}

extension PostedMessagesViewController: MessageTableViewDataSource {
    func getMessageDatas() -> [MessageData] {
        return messageDatas
    }
}
