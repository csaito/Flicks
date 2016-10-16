//
//  MovieItemTableViewCell.swift
//  Flicks
//
//  Created by Chihiro Saito on 10/15/16.
//  Copyright © 2016 Chihiro Saito. All rights reserved.
//

import UIKit

class MovieItemTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func isTruncated(labelToCheck: UILabel) -> Bool {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelToCheck.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = labelToCheck.font
        label.text = labelToCheck.text
        label.sizeToFit()
        if label.frame.height > labelToCheck.frame.height {
            return true
        }
        return false
    }

}
