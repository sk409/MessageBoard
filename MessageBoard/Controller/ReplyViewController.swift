import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var messageTableView: MessageTableView!
    
    private var targetMessageData: MessageData?
    private var replyMessageDatas = [MessageData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.setMessageDataSource(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchReplayMessageDatas()
    }

    @IBAction func goBackButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setTargetMessage(_ targetMessageData: MessageData) {
        self.targetMessageData = targetMessageData
    }
    
    private func fetchReplayMessageDatas() {
        guard let settings = Application.settings else {
            return
        }
        guard let viewerUserName = UserManager.userName else {
            return
        }
        guard let session = DatabaseSession(mediator: "get_reply.php", webServerHost: settings.webServerHost) else {
            return
        }
        guard let targetMessageData = self.targetMessageData else {
            return
        }
        let queries = settings.getQueries(merge: ["dest_message_id": String(targetMessageData.id), "dest_message_user_name": targetMessageData.userName, "viewer_user_name": viewerUserName])
        guard let response = session.sync(queries: queries, method: .get) else {
            return
        }
        guard let data = response.data else {
            return
        }
        guard let replyMessageDatas = try? JSONDecoder().decode([MessageData].self, from: data) else {
            return
        }
        self.replyMessageDatas = replyMessageDatas
        messageTableView.reloadData()
    }
}

extension ReplyViewController: MessageTableViewDataSource {
    func getMessageDatas() -> [MessageData] {
        return replyMessageDatas
    }
}
