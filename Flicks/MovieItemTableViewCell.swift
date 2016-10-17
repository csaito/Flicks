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


}
