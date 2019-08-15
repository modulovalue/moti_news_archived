//
//  FirstViewController.swift
//  Moti News
//
//  Created by Modestas Valauskas on 04.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import UIKit
import Foundation
import SafariServices
class FirstViewController: UITableViewController, UIGestureRecognizerDelegate, CustomTableViewCellDelegate {


    var indicatorView: UIView = UIView()
    
    lazy var refreshControl2: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FirstViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var data: [RssData] = []
    
    var scrollTimer: NSTimer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        tableView.delegate = self
//        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        self.tableView.addSubview(self.refreshControl2)
        view.userInteractionEnabled = true
        
        
        
//        let tap: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FirstViewController.handleTap(_:)))
//        tap.minimumPressDuration = CFTimeInterval(DBL_EPSILON)
//        tableView.addGestureRecognizer(tap)
//        tap.cancelsTouchesInView = false
//        tap.delegate = self
        
        tableView.sizeToFit()
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        indicatorView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width / 2, 0, 0, 4))
        indicatorView.backgroundColor = UIColor(red: 0, green: 204/355, blue: 255/255, alpha: 1)
        self.indicatorView.alpha = 0
        UIApplication.sharedApplication().keyWindow?.addSubview(indicatorView)
        
    }
    
    func animateProgressBar() {
        UIView.animateWithDuration(
              0.40,
              delay: 0.1,
              options: UIViewAnimationOptions.TransitionNone,
              animations: {
                self.indicatorView.alpha = 1
                self.indicatorView.layer.bounds.size.width = self.view.bounds.size.width
              },
              completion: {
                (value: Bool) in
                self.indicatorView.alpha = 0
                self.indicatorView.layer.bounds.size.width = 0
        })
        
    }
    
    func stopIndicatorAnimations() {
        indicatorView.alpha = 0
        indicatorView.layer.bounds.size.width = 0
        indicatorView.layer.removeAllAnimations()
    }
    
    var firstFlichBool = -1
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        firstFlichBool = -1
        return true
    }
    
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        if(firstFlichBool == -1 && recognizer.state == UIGestureRecognizerState.Began) {
            animateProgressBar()
        }
        
        if(firstFlichBool == -1 && recognizer.state == UIGestureRecognizerState.Changed) {
            stopIndicatorAnimations()
            if(abs(tableView.panGestureRecognizer.velocityInView(tableView).y) > 450) {
                firstFlichBool = 1
            }  else {
                firstFlichBool = 2
            }
        }
        
        if(firstFlichBool == 1) {
            if(recognizer.state == UIGestureRecognizerState.Changed) {
                for dat in data {
                    dat.cellState = .Normal
                }
                tableView.reloadData()
            }
            
        } else if(firstFlichBool == 2) {
            if(recognizer.state == UIGestureRecognizerState.Changed) {
                for dat in data {
                    dat.cellState = .Menu
                }
                tableView.reloadData()
            }
        }
        
        if(firstFlichBool == 2 && recognizer.state == UIGestureRecognizerState.Ended) {
            for dat in data {
                dat.cellState = .Normal
            }
            tableView.reloadData()
        }

    }
    

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data.count == 0) {
            return 1
        } else {
            return data.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("newsview", forIndexPath: indexPath) as! CustomTableViewCell

        if(data.isEmpty) {
            cell.sizeToFitCustom()
            populateData(cell.mainText.bounds.width, widthOfTitle: cell.title.bounds.width)
            tableView.reloadData()
            cell.img.image = UIImage(named: "zutzut")
            cell.mainText.attributedText = NSAttributedString(string: "Lädt...")
        } else {
            cell.img.image = data[indexPath.row].getImg()
            cell.mainText.attributedText = data[indexPath.row].getAttributedString()
            cell.title.attributedText = data[indexPath.row].getAttributedStringTitle()
            cell.setCellState(data[indexPath.row].cellState)
            cell.delegate = self
            cell.urlString = data[indexPath.row].getLink()
        }
        
        return cell
        
    }
    
    

    func populateData(widthOfText: CGFloat, widthOfTitle: CGFloat) {
        data.append(RssData(
            link: "https://www.martinshare.com",
            img: UIImage(named: "Logo"),
            string: "Imen? Einschätzungen gibt es vorab von Stürmer Mario Gomez und Abwehrspieler Mats Hummels. ",
            stringTitle: "Neue App für übersichtliche Neuigkeiten"
            )
        )
        data.append(RssData(
            link: "https://www.martinshare.com",
            img: UIImage(named: "Logo"),
            string: "Imen? Einschätzungen gibt es vorab von Stürmer Mario Gomez und Abwehrspieler Mats Hummels. ",
            stringTitle: "Neue App für übersichtliche Neuigkeiten"
            )
        )
        data.append(RssData(
            link: "https://www.martinshare.com",
            img: UIImage(named: "zutzutzut"),
            string: "Imen? Einschätzungen gibt es vorab von Stürmer Mario Gomez und Abwehrspieler Mats Hummels. ",
            stringTitle: "Neue App für übersichtliche Neuigkeiten"
            )
        )
        data.append(RssData(
            link: "https://www.martinshare.com",
            img: UIImage(named: "AppIcon"),
            string: "Bombe tötet 127 Menschen in Italien ok at sich",
            stringTitle: "Neue App für übersichtliche Neuigkeiten"
            )
        )
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showSafari(data[indexPath.row].getLink())
        animateProgressBar()
    }
    
    func showSafari(link:String) {
        let svc = SFSafariViewController(URL: NSURL(string: link)!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}

