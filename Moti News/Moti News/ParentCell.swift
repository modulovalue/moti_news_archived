//
//  ParentCell.swift
//  Moti News
//
//  Created by Modestas Valauskas on 09.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import UIKit

class ParentCell: UITableViewCell {

    
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var activeInfoText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
