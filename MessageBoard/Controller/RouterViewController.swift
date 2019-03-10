import UIKit

class RouterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        add(child: EntranceViewController())
    }
    
    func reset(to rootViewController: UIViewController) {
        guard let child = children.first else {
            return
        }
        if child.presentingViewController != nil {
            child.dismiss(animated: true)
        }
        child.willMove(toParent: nil)
        child.removeFromParent()
        child.view.removeFromSuperview()
        add(child: rootViewController)
    }
    
    private func add(child viewController: UIViewController) {
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
    }

}
