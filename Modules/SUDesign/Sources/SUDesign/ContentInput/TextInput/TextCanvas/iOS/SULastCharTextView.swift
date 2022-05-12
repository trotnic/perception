//
//  SULastCharTextView.swift
//  
//
//  Created by Uladzislau Volchyk on 12.05.22.
//

#if os(iOS)
import UIKit

final class SULastCharTextView: UITextView {

  private let onComplete: () -> Void

  init(frame: CGRect, onComplete: @escaping () -> Void) {
    self.onComplete = onComplete
    super.init(frame: frame, textContainer: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func deleteBackward() {
    if text.isEmpty || text == " " {
      onComplete()
    }
    super.deleteBackward()
  }
}
#endif
