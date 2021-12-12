//
//  PCNTableViewCell.swift
//  
//
//  Created by Uladzislau Volchyk on 11.12.21.
//

import UIKit

public final class PCNCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 12.0)
    }

    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var rightImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        rightImageView.image = PCNIconHolder.icon(of: .chevronLeft)
        
        backgroundColor = PCNDesignHolder.color(\.tile)

        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public interface

extension PCNCollectionViewCell {

    public override var layoutMargins: UIEdgeInsets {
        get {
            Constants.edgeInsets
        }
        set {
            super.layoutMargins = newValue
        }
    }
}

// MARK: - Private interface

private extension PCNCollectionViewCell {

    func setupLayout() {
        addSubview(rightImageView)
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
