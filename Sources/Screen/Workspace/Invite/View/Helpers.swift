//
//  Helpers.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 16.05.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import Foundation

extension NSPredicate {
  static let emailPredicate: NSPredicate = {
    let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
    let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
    let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegEx)
  }()
}

extension String {

  
  var isValidEmail: Bool {
    
    return NSPredicate.emailPredicate.evaluate(with: self)
  }
}

//extension String {
//
//  final class EmailValidationSubscription<S: Subscriber>: Subscription where S.Input == Bool {
//    private let subscriber: S?
//
//    init(
//      subscriber: S
//    ) {
//      self.subscriber = subscriber
//    }
//
//    func request(_ demand: Subscribers.Demand) {
//      subscriber?.receive(self.isValid)
//    }
//  }
//}
