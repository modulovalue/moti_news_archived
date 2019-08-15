//
//  CustomTableViewCell.swift
//  Moti News
//
//  Created by Modestas Valauskas on 04.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var mainText: UITextView!
    
    //@IBOutlet weak var tick: UIImageView!
    
    private var cellState = CellState.Normal
    
    var isRead = false
    
    @IBOutlet weak var sideIndicator: UIView!
    
    @IBOutlet weak var title: UITextView!
    
    var img: UIImageView = UIImageView()
    var imgParentView = UIView()
    var titleView = UIView()
    
    var urlString = "http://www.google.de"
    
    var delegate: CustomTableViewCellDelegate?
    
  //  var blackView: UIView = UIView()
    
 //   var data: RssData! = nil
    var button: UIButton = UIButton()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
//        // Initialization code
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.tickTapped(_:)))
//        
//        // add it to the image view;
//        tick.addGestureRecognizer(tapGesture)
//        // make sure imageView can be interacted with by user
//        tick.userInteractionEnabled = true
//        
        if(isRead == true) {
            read(false)
        } else {
            unread(false)
        }
        

       // initBlackOverlay()
        
        
        if(img.image == nil) {
            img = UIImageView(image: UIImage(named: "zutzutzut"))
        }
        
        img.frame = CGRectMake(self.layer.bounds.width - 100, 15, 90, 90)
        img.alpha = 0
        img.contentMode = .ScaleAspectFill
        img.layer.anchorPoint = CGPointMake(0.5,0.5);
        img.layer.cornerRadius = 5
        img.clipsToBounds = true;
        img.opaque = true
        
        
        
        imgParentView.layer.shadowColor = UIColor.blackColor().CGColor
        imgParentView.layer.shadowOffset = CGSizeMake(0, 0);
        imgParentView.layer.shadowOpacity = 0.08;
        imgParentView.layer.shadowRadius = 5;
        imgParentView.addSubview(img)
        imgParentView.frame.origin.x = 30
        
        
        button = UIButton(frame: CGRect(x: 10, y: 75, width: (self.layer.bounds.width - 100) / 3, height: 20))
        button.backgroundColor = UIColor.darkGrayColor()
        button.alpha = 0
        button.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 13)
        button.setTitle("Öffnen", forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        button.layer.cornerRadius = 5
        
        
        self.addSubview(button)
        
    
        let headerLabel = UILabel()
        headerLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        headerLabel.text = "Heute Leute wirds was geben Hia Hia Hoooo Neuigkeiten"
        headerLabel.numberOfLines = 2
        headerLabel.textAlignment = .Left
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.frame = CGRectMake(5, 5,  self.layer.bounds.width - 10 - 130, 40)
        headerLabel.layer.anchorPoint = CGPointMake(0.5,0.5);
        headerLabel.opaque = true
        
        
        titleView.frame = CGRectMake(10, 15, self.layer.bounds.width - 125, 55)
        titleView.frame.origin.x = 60
        titleView.layer.anchorPoint = CGPointMake(0.5,0.5);
        titleView.layer.cornerRadius = 5
        titleView.alpha = 0
        titleView.clipsToBounds = true;
        titleView.backgroundColor = UIColor.darkGrayColor()
        
        titleView.addSubview(headerLabel)
        

        
        self.addSubview(titleView)
        self.addSubview(imgParentView)
        

    }
    
    func sizeToFitCustom() {
        title.sizeToFit()
        mainText.sizeToFit()
    }

    func buttonAction(sender: UIButton!) {
        delegate!.showSafari(self.urlString)
    }


    func setCellState(cellState: CellState) {
    
        if(self.cellState == .ReadyToOpen && cellState == .Normal) {
            self.cellState = .ReadyToClose
        } else {
            self.cellState = cellState
        }
        
        if(cellState == CellState.Normal) {
//            hideImage()
//            hideBlackOverlay()
            print("normal")
        } else if(cellState == CellState.Menu) {
//            showImage()
//            hideBlackOverlay()
            print("MENU")
        } else if(cellState == CellState.ReadyToOpen) {
          //  showBlackOverlay()
            print("READY TO OPEN")
        }
        
    }
    
    
    func initBlackOverlay() {
        //blackView = UIView(frame: layer.frame)
        //blackView.backgroundColor = UIColor.blackColor()
        //blackView.alpha = 0
        //addSubview(blackView)
    }
    
    func showBlackOverlay() {
        //blackView.frame = CGRectMake(0,0,frame.width,frame.height)
        //self.blackView.alpha = 0.4
        
        UIView.animateWithDuration(0.35, animations: {
            self.button.alpha = 1
        })
        
    }
    
    func hideBlackOverlay() {
        //self.blackView.alpha = 0
    }
    
    func showImage() {
        UIView.animateWithDuration(0.35, animations: {
            self.img.alpha = 1
            self.titleView.alpha = 1
            self.titleView.frame.origin.x = 10
            self.imgParentView.frame.origin.x = 0
        })
    }
    
    func hideImage() {
        UIView.animateWithDuration(0.35, animations: {
            self.img.alpha = 0
            self.titleView.alpha = 0
            self.titleView.frame.origin.x = 60
            self.imgParentView.frame.origin.x = 30
            self.button.alpha = 0
        })
    }
    
//    
//    func tickTapped(gesture: UIGestureRecognizer) {
//        if(isRead == true) {
//            unread(true)
//        } else if (isRead == false) {
//            read(true)
//        }
//    }
//    

    func read(bool: Bool) {
        if(bool) {
           // let tempImageView = UIImageView(image: UIImage(named: "read"))
            //moveImageTo(tempImageView)
        }
        sideIndicator.backgroundColor = UIColor(red:0.69, green:0.69, blue:0.69, alpha:1.0)
        isRead = true
        //tick.image = UIImage(named: "read")
    }
    
    func unread(bool: Bool) {
        if(bool) {
           // let tempImageView = UIImageView(image: UIImage(named: "unread"))
           // moveImageTo(tempImageView)
        }
        sideIndicator.backgroundColor = UIColor(red:0.00, green:0.20, blue:0.20, alpha:1.0)
        isRead = false
        //tick.image = UIImage(named: "unread")
    }
    
//    func moveImageTo(tempImageView: UIImageView){
//        
//        tempImageView.frame = CGRectMake(self.bounds.width / 2, self.bounds.height/2, 50, 50)
//        tempImageView.alpha = 1
//        tempImageView.contentMode = .ScaleAspectFill
//        tempImageView.layer.anchorPoint = CGPointMake(1, 1);
//        
//        self.addSubview(tempImageView)
//        
//        UIView.animateWithDuration(0.4, animations: {
//            
//            tempImageView.frame = CGRectMake(self.bounds.width / 2 - 120, self.bounds.height/2 - 120, 240, 240)
//            tempImageView.alpha = 0
//            tempImageView.layer.anchorPoint = CGPointMake(1, 1);
//            
//            }, completion: {
//                (value: Bool) in
//                tempImageView.removeFromSuperview()
//        })
//    }
//

}