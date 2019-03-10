import UIKit

protocol MessageTableViewDataSource {
    func getMessageDatas() -> [MessageData]
}

class MessageTableView: UITableView {
    
    private var messageDataSource: MessageTableViewDataSource?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func setMessageDataSource(_ messageDataSource: MessageTableViewDataSource) {
        self.messageDataSource = messageDataSource
    }
    
    private func initialize() {
        delegate = self
        dataSource = self
        register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
    }
    
}

extension MessageTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let messageDataSource = self.messageDataSource else {
            return 0
        }
        let messageDatas = messageDataSource.getMessageDatas()
        return messageDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messageDataSource = self.messageDataSource else {
            return UITableViewCell()
        }
        let messageDatas = messageDataSource.getMessageDatas()
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as! MessageTableViewCell
        cell.setData(messageData: messageDatas[indexPath.row], reloadTable: tableView.reloadData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let messageDataSource = self.messageDataSource else {
            return
        }
        let messageDatas = messageDataSource.getMessageDatas()
        let replyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        replyViewController.setTargetMessage(messageDatas[indexPath.row])
        guard let topViewController = Application.getTopViewController() else {
            return
        }
        topViewController.present(replyViewController, animated: true)
    }
}
