import Foundation
import SnapKit
import UIKit

protocol ContainerViewType {
    var contentView: UIView { get set }
}

extension ContainerViewType where Self: UIViewController {
    func add(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }

    func remove(asChildViewController viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
