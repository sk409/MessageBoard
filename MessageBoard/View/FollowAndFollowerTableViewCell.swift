import UIKit

class FollowAndFollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(userName: String) {
        userNameLabel.text = userName
    }
    
    private func configureUserImage() {
        userImage.layer.borderWidth = 1
        userImage.layer.borderColor = UIColor.black.cgColor
    }
    
}
