//
//  ChildrenCell.swift
//  Moti News
//
//  Created by Modestas Valauskas on 09.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import UIKit

class ChildrenCell: UITableViewCell {

    @IBOutlet weak var textLbl: UILabel!

    var link = ""
    
    @IBOutlet weak var enabledImg: UIImageView!
    
    var enabled: Bool = false
    
    var openInTableView = false
    
    @IBOutlet weak var indicatorArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func invert() {
        if(enabled) {
            setDisabled()
        } else {
            setEnabled()
        }
    }
    
    func setEnabled() {
        enabled = true
        UIView.animateWithDuration(NSTimeInterval(0.2), animations: {
            self.enabledImg.image = UIImage(named: "tickon")
            self.enabledImg.alpha = 1
            self.textLbl.alpha = 1
            self.indicatorArrow.alpha = 1
        })
        print("enable")
    }
    
    
    func setDisabled() {
        enabled = false
        UIView.animateWithDuration(NSTimeInterval(0.34), animations: {
            self.enabledImg.image = UIImage(named: "tickoff")
            self.enabledImg.alpha = 0.4
            self.textLbl.alpha = 0.4
            self.indicatorArrow.alpha = 0.4
        })
        print("disable")
    }

}
