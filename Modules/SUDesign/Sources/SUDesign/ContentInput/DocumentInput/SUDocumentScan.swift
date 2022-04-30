//
//  SUDocumentScan.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 24.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

#if os(iOS)

import SwiftUI
import VisionKit

public struct SUDocumentScan: UIViewControllerRepresentable {

  public let onFinishScan: ([UIImage]) -> Void

  public init(
    onFinishScan: @escaping ([UIImage]) -> Void
  ) {
    self.onFinishScan = onFinishScan
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(onFinish: onFinishScan)
  }

  public func makeUIViewController(context: Context) -> some UIViewController {
    let documentCameraViewController = VNDocumentCameraViewController()
    documentCameraViewController.delegate = context.coordinator
    return documentCameraViewController
  }

  public func updateUIViewController(
    _ uiViewController: UIViewControllerType,
    context: Context
  ) {}

  public final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    let onFinish: ([UIImage]) -> Void

    init(onFinish: @escaping ([UIImage]) -> Void) {
      self.onFinish = onFinish
    }

    public func documentCameraViewController(
      _ controller: VNDocumentCameraViewController,
      didFinishWith scan: VNDocumentCameraScan
    ) {
      DispatchQueue.global(qos: .userInitiated).async {
        self.onFinish((0..<scan.pageCount).map(scan.imageOfPage(at:)))
      }
    }
  }
}

#endif
