import UIKit

class SettingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var settingItemName: UILabel!
    @IBOutlet weak var settingContents: UITextField!
    
    private var queryParameterName: String?
    private var notification: ((String, String) -> Void)?
    
    func setData(itemName: String, contents: String, queryParameterName: String, notification: @escaping (String, String) -> Void) {
        settingItemName.text = itemName
        settingContents.text = contents
        settingContents.addTarget(self, action: #selector(settingContentsChanged), for: .editingChanged)
        self.queryParameterName = queryParameterName
        self.notification = notification
    }
    
    @objc private func settingContentsChanged() {
        guard let notification = self.notification else {
            return
        }
        guard let queryParameterName = self.queryParameterName else {
            return
        }
        guard let settingContents = self.settingContents.text else {
            return
        }
        notification(queryParameterName, settingContents)
    }
    
}
