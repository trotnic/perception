//
//  PCNAuthViewController.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 12.12.21.
//  Copyright © 2021 Star Unicorn. All rights reserved.
//

import UIKit
import PerceptionStorage

class PCNAuthViewController: UIViewController {

    private lazy var userOneButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleAuth(_:)), for: .touchUpInside)
        view.setTitle("kek1@gmail.com", for: .normal)
        return view
    }()

    private lazy var userTwoButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleAuth(_:)), for: .touchUpInside)
        view.setTitle("kek2@gmail.com", for: .normal)
        return view
    }()
}

extension PCNAuthViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(userOneButton)
        view.addSubview(userTwoButton)
    }
}

private extension PCNAuthViewController {
    
    @objc func handleAuth(_ sender: UIButton) {
        if sender === userOneButton {
            PCNFireManager.shared.authManager.signIn(
                email: "kek1@gmail.com",
                password: "lolkekcheburek"
            ) { [self] in
                navigationController?.pushViewController(PCNDocumentViewController(), animated: true)
            }
        } else if sender === userTwoButton {
            PCNFireManager.shared.authManager.signIn(
                email: "kek2@gmail.com",
                password: "lolkekcheburek"
            ) { [self] in
                navigationController?.pushViewController(PCNDocumentViewController(), animated: true)
            }
        }
    }
}
