//
//  ViewController.swift
//  keklolkek
//
//  Created by Uladzislau Volchyk on 2.04.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Controller"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.navigationBar.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

