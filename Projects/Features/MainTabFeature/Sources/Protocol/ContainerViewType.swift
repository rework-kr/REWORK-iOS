import Foundation
import SnapKit
import UIKit

protocol ContainerViewType {
    var contentView: UIView { get set }
}

extension ContainerViewType where Self: UIViewController {
    func add(asChildViewController viewController: UIViewController?) {
        guard let viewController else { return }
        print("add!!")
        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }

    func remove(asChildViewController viewController: UIViewController?) {
        guard let viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        print("remove!!")
    }
}
