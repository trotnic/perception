//
//  PCNListViewController.swift
//  Perception
//
//  Created by Uladzislau Volchyk on 11.12.21.
//  Copyright © 2021 Star Unicorn. All rights reserved.
//

import UIKit
import PerceptionUI

typealias PCNListDataSource = UICollectionViewDiffableDataSource<Section, String>
typealias PCNListCellConfig = UICollectionView.CellRegistration<PCNCollectionViewCell, String>

enum Section {
    case ordinary
}

class PCNListViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var dataSource: PCNListDataSource = {
        PCNListDataSource(
            collectionView: collectionView,
            cellProvider: handler(collectionView:indexPath:itemIdentifier:)
        )
    }()

    private let simpleConfig: PCNListCellConfig = {
        PCNListCellConfig { cell, indexPath, itemIdentifier in

        }
    }()

    private func handler(
        collectionView collection: UICollectionView,
        indexPath: IndexPath,
        itemIdentifier: String
    ) -> UICollectionViewCell? {
        collection.dequeueConfiguredReusableCell(using: simpleConfig, for: indexPath, item: itemIdentifier)
    }
}

extension PCNListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.ordinary])
        snapshot.appendItems(["lolkek", "cheburek", "kek", "lol", "check"], toSection: .ordinary)
        dataSource.apply(snapshot)

        collectionView.backgroundColor = PCNDesignHolder.color(\.background)
    }
}

extension PCNListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 343, height: 114)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        24.0
    }
}
