//
//  SUImagePicker.swift
//  SUDesign
//
//  Created by Uladzislau Volchyk on 16.04.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import SwiftUI
import UIKit
import PhotosUI

#if os(iOS)
public struct SUImagePicker: UIViewControllerRepresentable {
  @Binding public var image: UIImage?

  public init(image: Binding<UIImage?>) {
    _image = image
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(
    _ uiViewController: PHPickerViewController,
    context: Context
  ) {
    
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: SUImagePicker

    init(_ parent: SUImagePicker) {
      self.parent = parent
    }

    public func picker(
      _ picker: PHPickerViewController,
      didFinishPicking results: [PHPickerResult]
    ) {
      picker.dismiss(animated: true)

      guard let provider = results.first?.itemProvider else { return }

      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, _ in
          self.parent.image = image as? UIImage
        }
      }
    }
  }
}
#endif
