//
//  PCNIconHolder.swift
//  
//
//  Created by Uladzislau Volchyk on 11.12.21.
//

import UIKit

public enum PCNIcon: String {
    case ellipsis = "ellipsis"
    case chevronLeft = "chevron.left"
    case xmark = "xmark"
    case sliderHorizontal = "slider.horizontal.3"
    case highlighter = "highlighter"
    case magnifyingglass = "magnifyingglass"
    case gearshape = "gearshape"
    case lineHorizontal = "line.3.horizontal"
    case personTwo = "person.2"
    case link = "link"
    case plus = "plus"
}

public final class PCNIconHolder {
    
    static func icon(of: PCNIcon) -> UIImage {
        UIImage(systemName: of.rawValue)!
    }
}
