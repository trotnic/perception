//
//  PCNIconHolder.swift
//  
//
//  Created by Uladzislau Volchyk on 11.12.21.
//

import UIKit

public final class PCNButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.width / 2
        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
