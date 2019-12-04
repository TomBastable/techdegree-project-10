//
//  MasterTableViewCell.swift
//  P10 Diary
//
//  Created by Tom Bastable on 03/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
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
