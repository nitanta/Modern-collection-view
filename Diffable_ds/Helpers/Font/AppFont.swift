//
//  AppFont.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 1/7/22.
//

import Foundation
import UIKit

struct AppFont {
    
    static var system12: UIFont {
        let font = UIFont.systemFont(ofSize: 12)
        let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)
        return fontMetrics.scaledFont(for: font)
    }
    
}
