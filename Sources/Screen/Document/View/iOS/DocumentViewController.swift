//
//  DocumentViewController.swift
//  Perception-iOS
//
//  Created by Uladzislau Volchyk on 8.05.22.
//  Copyright © 2022 Star Unicorn. All rights reserved.
//

import Combine
import UIKit
import SUDesign
import SwiftUI

struct DocumentViewWrapper: UIViewControllerRepresentable {
  let documentViewModel: DocumentViewModel
  let settingsViewModel: ToolbarSettingsViewModel

  func makeUIViewController(context: Context) -> DocumentViewController {
    DocumentViewController(documentViewModel: documentViewModel, settingsViewModel: settingsViewModel)
  }

  func updateUIViewController(_ uiViewController: DocumentViewController, context: Context) {}
}

// MARK: - UI

final class DocumentViewController: UIViewController {

  private let documentViewModel: DocumentViewModel
  private let settingsViewModel: ToolbarSettingsViewModel

  init(
    documentViewModel: DocumentViewModel,
    settingsViewModel: ToolbarSettingsViewModel
  ) {
    self.documentViewModel = documentViewModel
    self.settingsViewModel = settingsViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private var backButton: UIButton!

  private var emojiField: EmojiTextField!
  private var titleField: UITextField!
  private var topTileView: UIView!

  private var contentView: UIScrollView!

  private var disposeBag = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(SUColorStandartPalette.background)

    backButton = UIButton()
    backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    backButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backButton)
    NSLayoutConstraint.activate([
      backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
      backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16.0),
    ])

    contentView = UIScrollView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    contentView.backgroundColor = .red

    documentViewModel
      .$items
      .sink { items in
        items.forEach { docBlock in
          
        }
      }
      .store(in: &disposeBag)
  }
}
