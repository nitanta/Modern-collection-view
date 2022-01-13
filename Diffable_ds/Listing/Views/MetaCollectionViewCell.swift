//
//  MetaCollectionViewCell.swift
//  Diffable_ds
//
//  Created by Nitanta Adhikari on 12/30/21.
//

import UIKit

class MetaCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MetaCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFont.system12
        
        titleLabel.textColor = AppColor.primaryText
        
        titleLabel.accessibilityLabel = AccessibilityIdentifiers.ListViewCell.titleLabel
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? AppColor.seperator: AppColor.background
        }
    }
    
}
