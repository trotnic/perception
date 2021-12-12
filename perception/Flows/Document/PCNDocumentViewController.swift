//
//  PCNDocumentViewController.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 12.12.21.
//  Copyright © 2021 Star Unicorn. All rights reserved.
//

import UIKit

class PCNDocumentViewController: UIViewController {

    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension PCNDocumentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
    }
}

private extension PCNDocumentViewController {

    private func setupTextView() {
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
