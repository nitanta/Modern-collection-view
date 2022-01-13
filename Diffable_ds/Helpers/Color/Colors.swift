//
//  Colors.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 1/5/22.
//

import UIKit

struct AppColor {
    @Theme(light: UIColor.white,
           dark: UIColor.safeSystemBackground)
    static var background: UIColor

    @Theme(light: UIColor(hex: "333333"),
           dark: UIColor.safeLabel)
    static var primaryText: UIColor

    @Theme(light: UIColor(hex: "EEEFF2"),
           dark: UIColor.safeSeperator)
    static var seperator: UIColor
    
    @Theme(light: UIColor(hex: "1F82FB"),
           dark: UIColor(hex: "7C7FED"))
    static var navBar: UIColor
    
}

// MARK: - BackPort iOS 13 and older Colors
extension UIColor {
    static var safeSystemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        } else {
            return .black
        }
    }

    static var safeLabel: UIColor {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .white
        }
    }

    static var safeSeperator: UIColor {
        if #available(iOS 13, *) {
            return .separator
        } else {
            return UIColor.gray.withAlphaComponent(0.6)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
