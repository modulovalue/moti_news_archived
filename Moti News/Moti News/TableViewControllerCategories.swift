//
//  TableViewControllerCategories.swift
//  Moti News
//
//  Created by Modestas Valauskas on 09.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//

import UIKit

class TableViewControllerCategories: UITableViewController {
    
    var values: [String : NSDictionary] = [:]
    var cellCount = 0
    var cellCountArray: [String] = []
    var cellArrayOpen: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let language = "DE"
        values = NSBundle.contentsOfFile("\(language)_Domains.plist") as! [String : NSDictionary]
        
        
        for item in values {
            cellCount += 1
            if(cellCountArray.count <= cellCount) {
                cellCountArray.append("Parent")
                cellArrayOpen.append(true)
            }
            for item2 in item.1 {
                for _ in item2.value as! NSDictionary {
                    if(cellCountArray.count <= cellCount) {
                        cellCountArray.append("Child")
                        cellArrayOpen.append(false)
                    }
                    cellCount += 1
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell is ChildrenCell) {
            (cell as! ChildrenCell).invert()
        } else if (cell is ParentCell) {
            
            print("ok \(indexPath.row)")
            
            for(indx, value) in cellCountArray.enumerate() {
                if(indx <= indexPath.row) {
                    
                } else {
                    if(value == "Child") {
                        cellArrayOpen[indx] = !cellArrayOpen[indx]
                    } else {
                        break
                    }
                }
            
            }
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(cellArrayOpen[indexPath.row] == true) {
            return 44
        } else {
            return 0
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellCountMomentary = -1
        
        var cellP: ParentCell! = nil
        var cellC: ChildrenCell! = nil
        
        for item in values {
            cellCountMomentary += 1
            
         
            if(cellCountMomentary == indexPath.row) {
                cellP = tableView.dequeueReusableCellWithIdentifier("parentCell") as! ParentCell
                cellP.textLbl.text = item.0
                break
            }
            
            for item2 in item.1 {
                
                for item3 in item2.value as! NSDictionary {
                    
                    cellCountMomentary += 1
                
                    if(cellCountMomentary == indexPath.row) {
                        cellC = tableView.dequeueReusableCellWithIdentifier("childCell") as! ChildrenCell
                        cellC.textLbl.text = "\(item3.key)"
                        
                        
                        for item4 in item3.value as! NSDictionary {
                            if(item4.key as! String == "default") {
                                if(item4.value as! Bool == true) {
                                    cellC.setEnabled()
                                } else {
                                    cellC.setDisabled()
                                }
                            }
                        }
                        
                        break
                    }
                }
            }
        }
        
        if(cellP != nil) {
            return cellP
        } else if(cellC != nil) {
            return cellC
        } else {
                
            let cell2 = tableView.dequeueReusableCellWithIdentifier("childCell", forIndexPath: indexPath) as! ChildrenCell
            return cell2
        }

    }

}
