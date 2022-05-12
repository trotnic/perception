//
//  Helpers.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 12.05.22.
//

#if os(iOS)
import UIKit

extension UIBarButtonItem {
  private struct AssociatedObject {
    static var key = "action_closure_key"
  }

  var callback: (() -> Void)? {
    get {
      objc_getAssociatedObject(self, &AssociatedObject.key) as? () -> Void
    }
    set {
      objc_setAssociatedObject(self, &AssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      target = self
      action = #selector(didTapButton(sender:))
    }
  }

  @objc func didTapButton(sender: Any) {
    callback?()
  }

  convenience init(title: String, callback: @escaping () -> Void) {
    self.init(title: title, style: .plain, target: nil, action: nil)
    self.callback = callback
  }

  convenience init(image: UIImage?, callback: @escaping () -> Void) {
    self.init(image: image, style: .plain, target: nil, action: nil)
    self.callback = callback
  }
}

public extension String {
  func height(
    width: CGFloat,
    font: UIFont
  ) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: [.usesLineFragmentOrigin, .usesDeviceMetrics],
      attributes: [.font: font],
      context: nil
    )

    return ceil(boundingBox.height)
  }
}
#endif
