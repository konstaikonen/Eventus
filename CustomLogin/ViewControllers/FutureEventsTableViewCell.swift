//
//  FutureEventsTableViewCell.swift
//  CustomLogin
//
//  Created by formando on 18/01/2020.
//  Copyright © 2020 formando. All rights reserved.
//

import UIKit

class FutureEventsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var likeOut: LikeControl!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
