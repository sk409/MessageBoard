import UIKit

protocol PostViewControllerDelegate {
    func postMessage(contents: String) -> Bool
}

class PostViewController: UIViewController {

    @IBOutlet weak var messageText: UITextView!
    
    private var delegate: PostViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageText.layer.borderWidth = 1
        messageText.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func goBackToAccountVIewController(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postMessage(_ sender: Any) {
        let functionObserver = FunctionObserver() {
            Application.notification(on: self, message: "メッセージの投稿に失敗しました")
        }
        guard let delegate = self.delegate else {
            return
        }
        guard let contents = messageText.text else {
            return
        }
        guard !contents.isEmpty else {
            Application.notification(on: self, message: "メッセージを入力してください")
            return
        }
        let succeeded = delegate.postMessage(contents: contents)
        guard succeeded else {
            return
        }
        Application.notification(on: self, message: "メッセージを投稿しました") { _ in
            self.dismiss(animated: true)
        }
        functionObserver.complete()
    }
    
    func setDelegate(_ delegate: PostViewControllerDelegate) {
        self.delegate = delegate
    }
    
}
