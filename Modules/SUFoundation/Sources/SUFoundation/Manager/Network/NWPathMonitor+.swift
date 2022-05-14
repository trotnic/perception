//
//  NWPathMonitor+.swift
//  SUFoundation
//
//  Created by Uladzislau Volchyk on 14.05.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Network
import Combine

extension NWPathMonitor {

  final class NetworkStatusSubscription<S: Subscriber>: Subscription where S.Input == NWPath.Status {

    private let subscriber: S?
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    init(
      subscriber: S,
      monitor: NWPathMonitor,
      queue: DispatchQueue
    ) {
      self.subscriber = subscriber
      self.monitor = monitor
      self.queue = queue
    }

    deinit {
      cancel()
    }

    // 3
    func request(_ demand: Subscribers.Demand) {
      monitor.pathUpdateHandler = { [weak self] path in
        guard let self = self else { return }
        _ = self.subscriber?.receive(path.status)
      }
      monitor.start(queue: queue)
    }

    func cancel() {
      monitor.cancel()
    }
  }
  
  struct NetworkPublisher: Publisher {
    typealias Output = NWPath.Status
    typealias Failure = Never
    
    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    
    init(
      monitor: NWPathMonitor,
      queue: DispatchQueue
    ) {
      
      self.monitor = monitor
      self.queue = queue
    }
    
    func receive<S: Subscriber>(subscriber: S) where S.Failure == Never, S.Input == NWPath.Status {
      let subscription = NetworkStatusSubscription(
        subscriber: subscriber,
        monitor: monitor,
        queue: queue
      )
      
      subscriber.receive(subscription: subscription)
    }
  }
  
  func publisher(queue: DispatchQueue) -> NWPathMonitor.NetworkPublisher {
    NetworkPublisher(monitor: self, queue: queue)
  }
}
