//
//  Motify.swift
//  Moti News
//
//  Created by Modestas Valauskas on 04.07.16.
//  Copyright © 2016 Modestas Valauskas. All rights reserved.
//




// ------------ BE CAREFUL, SOME SPACES ARE NON BREAKING SPACES!!!!! (alt + space)

import Foundation
import UIKit

class Motify {
    
    
    static var debugPrint = false
    
    static var font: UIFont = UIFont(name: "Helvetica", size: 14)!
    
    static func Motify(widthOfText: CGFloat, text: String, language: String) -> NSAttributedString {
        
        let values = NSBundle.contentsOfFile("\(language)_Convert.plist")
        let attributedString = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName: font])
//         let attributedString = NSMutableAttributedString(string: text as String, attributes: label.typingAttributes)

        var words = attributedString.string.componentsSeparatedByString(" ")
        
        for(_, element) in (values["ColorAddNegative"] as! NSArray).enumerate() {
            MotifyColor(element as! String, attributedString: attributedString, foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor())
        }
        for(_, element) in (values["ColorAddPositive"] as! NSArray).enumerate() {
            MotifyColor(element as! String, attributedString: attributedString, foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor(red: 0, green: 120/255, blue: 0, alpha: 1)
            )
        }
        for(string, emoji) in values["ColorAddNegativeColorAndEmoji"] as! NSDictionary {
            MotifyColor(string as! String, attributedString: attributedString, foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor.redColor())
            MotifyEmoji(string as! String, attributedString: attributedString, emojiToAdd: "\(emoji) " )
        }
        for(string, emoji) in values["ColorAddPositiveColorAndEmoji"] as! NSDictionary {
            MotifyColor(string as! String, attributedString: attributedString, foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor(red: 0, green: 130/255, blue: 0, alpha: 1))
            MotifyEmoji(string as! String, attributedString: attributedString, emojiToAdd: "\(emoji) " )
        }
        for(string, emoji) in values["CountriesColorAndEmoji"] as! NSDictionary {
            MotifyColor(string as! String, attributedString: attributedString, foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor.blackColor())
            MotifyEmoji(string as! String, attributedString: attributedString, emojiToAdd: "\(emoji) " )
        }
        for(number, emoji) in values["Numbers"] as! NSDictionary {
            MotifySingleNumbers(number as! String, attributedString: attributedString, emojiToReplaceWith: "\(emoji)")
        }

        
        words = attributedString.string.componentsSeparatedByString(" ")
        Print.p(debugPrint, t: "POST: \(words)")
        
        
        var indexesToBreakAndWhereToInsert: [(indexToBreak: Int, whereToBreak: Int)] = []
        var lastIndexToBreak: (indexToBreak: Int, whereToBreak: Int) = (0, 0)
    
        
        while( lastIndexToBreak.indexToBreak < words.count - 1) {
            lastIndexToBreak = getLengthFromTo(words, from: lastIndexToBreak, maxWidth: widthOfText, lineNumber: indexesToBreakAndWhereToInsert.count )
            indexesToBreakAndWhereToInsert.append(lastIndexToBreak)
        }
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.alignment = NSTextAlignment.Left
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        Print.p(debugPrint, t: indexesToBreakAndWhereToInsert)

        var lastIndex = 0;
        var breake = 0
        
        for(index, element) in (indexesToBreakAndWhereToInsert).enumerate() {
            
            var printStr = "" as String
            
            for index in lastIndex ... element.indexToBreak {
                printStr = printStr + "\(words[index]) "
            }

            for (indx, word) in words.enumerate() {
                if(indx <= element.indexToBreak && indx >= lastIndex) {
                    breake += Int("\(word.endIndex)")!
                    breake += 1
                }
            }
            if(index > 0) {
                breake += 3
            }
            
            lastIndex = element.indexToBreak + 1
        
            Print.p(debugPrint, t: "index: \(index) breake \(breake)")
            
            if(breake <= attributedString.length) {
                Print.p(debugPrint, t: "BREAK AT \(breake)")
                attributedString.insertAttributedString(NSAttributedString(string: "\n \n"),atIndex: breake)
                let pS = NSMutableParagraphStyle(); pS.lineSpacing = 0; pS.lineHeightMultiple = 0.20;
                attributedString.addAttribute(NSParagraphStyleAttributeName, value: pS, range: NSMakeRange(breake, 2))
            }
            
        }
        
        attributedString.mutableString.replaceOccurrencesOfString(" ", withString: " ", options: [], range: NSRange(location: 0, length: attributedString.length))
        
        attributedString.mutableString.replaceOccurrencesOfString("  ", withString: " ", options: [], range: NSRange(location: 0, length: attributedString.length))
        
        
        return attributedString
        
    }
    
    
    
    static func insertStr(attributedString: NSMutableAttributedString, s: String, i: Int) {
        attributedString.insertAttributedString(NSMutableAttributedString(string: s, attributes: [String : NSObject]()), atIndex: i)
    }
    
    
    
    static private func getLengthFromTo(array: [String], from: (indexToBreak: Int, whereToBreak: Int), maxWidth: CGFloat, lineNumber: Int) -> (indexToBreak: Int, whereToBreak: Int) {
        
        Print.p(debugPrint, t: "MAX WIDTH ------------  \(maxWidth) single space width \((" " as NSString).sizeWithAttributes([NSFontAttributeName: self.font]).width)")
        
        var width: CGFloat = 0
        var indexToReturn = 0
        var whereToBreak = 0
        
        for(index, element) in (array).enumerate() {
            if( (lineNumber == 0 && index < from.indexToBreak) || (index <= from.indexToBreak && lineNumber > 0)) {
                
            } else {
               
                width += (element as NSString).sizeWithAttributes([NSFontAttributeName: self.font]).width
                if(index < array.count) {
                    width += (" " as NSString).sizeWithAttributes([NSFontAttributeName: self.font]).width
                }
                
                Print.p(debugPrint, t: "\(index)  \((element as NSString).sizeWithAttributes([NSFontAttributeName: self.font]).width) und \(width)  --\(array[index])--" )
                
                indexToReturn = index
                
            }
            
            if ( width >= maxWidth) {
                indexToReturn -= 1
                Print.p(debugPrint, t: "UUUUUUUUU \(indexToReturn) \(width - (element as NSString).sizeWithAttributes([NSFontAttributeName: self.font]).width)")
                break
            } else {
                whereToBreak += Int("\(element.endIndex)")!
                if(index < array.count - 1) {
                    whereToBreak += 1
                }
            }
            
        }
        
        return (indexToReturn, whereToBreak)
        
    }
    
    static func MotifyColor(typeOfStringToColor: String, attributedString: NSMutableAttributedString, foregroundColor: UIColor, backgroundColor: UIColor) -> NSMutableAttributedString {
        
        var attributedString2 = MotifySingleColor("\(typeOfStringToColor) ", attributedString: attributedString, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        attributedString2 = MotifySingleColor("\(typeOfStringToColor).", attributedString: attributedString2, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        attributedString2 = MotifySingleColor("\(typeOfStringToColor),", attributedString: attributedString2, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        attributedString2 = MotifySingleColor("\(typeOfStringToColor):", attributedString: attributedString2, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        
        let words = attributedString.string.componentsSeparatedByString(" ")
        
        // check if last word
        if(words[words.count-1] == typeOfStringToColor) {
            
            //Add Whitespaces at the end and in the front for Design purposes
            insertStr(attributedString, s: "\u{00a0}", i: Int("\(attributedString.string.endIndex)")! - Int("\(typeOfStringToColor.endIndex)")! )
            insertStr(attributedString, s: "\u{00a0}", i: Int("\(attributedString.string.endIndex)")! )
            
            //Color new range with Whitespace at the beginning and end
            
            attributedString.addAttribute( NSForegroundColorAttributeName, value: foregroundColor, range: NSRange(location: Int("\(attributedString.string.endIndex)")! - Int("\(typeOfStringToColor.endIndex)")! - 2 , length: Int("\(typeOfStringToColor.endIndex)")! + 2))
            attributedString.addAttribute( NSBackgroundColorAttributeName, value: backgroundColor, range: NSRange(location: Int("\(attributedString.string.endIndex)")!  - Int("\(typeOfStringToColor.endIndex)")! - 2 , length: Int("\(typeOfStringToColor.endIndex)")! + 2))
            
            // add emoji to last word
            
            
        }
        
        return attributedString2
        
    }
    
    static func MotifySingleColor(typeOfStringToColor: String, attributedString: NSMutableAttributedString, foregroundColor: UIColor, backgroundColor: UIColor) -> NSMutableAttributedString {
        
        let inputLength = Int("\(attributedString.string.endIndex)")!
        let searchString = "\(typeOfStringToColor)"
        
        var range = NSRange(location: 0, length: attributedString.length)
        
        while (range.location != NSNotFound) {
            
            range = (attributedString.string as NSString).rangeOfString(searchString, options: [], range: range)
            
            if (range.location != NSNotFound) {
                
                //Add Whitespaces at the end and in the front for Design purposes
                
                insertStr(attributedString, s: "\u{00a0}", i: range.location + range.length - 1)
                insertStr(attributedString, s: "\u{00a0}", i: range.location)
            
                
                //Color new range with Whitespace at the beginning and end
                
                attributedString.addAttribute( NSForegroundColorAttributeName, value: foregroundColor, range: NSRange(location: (range.location == 0 ) ? range.location : range.location , length: Int("\(searchString.endIndex)")! + 1))
                attributedString.addAttribute( NSBackgroundColorAttributeName, value: backgroundColor, range: NSRange(location: (range.location == 0 ) ? range.location : range.location , length: Int("\(searchString.endIndex)")! + 1))
                
                range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                
            }
        }
        
 
        
        return attributedString
        
    }
    
    static func MotifyEmoji(typeOfStringToEmoji: String, attributedString: NSMutableAttributedString, emojiToAdd: String) -> NSMutableAttributedString {
        
        var attributedString2 = MotifySingleEmoji("\(typeOfStringToEmoji)\u{00a0} ", attributedString: attributedString, emojiToAdd: emojiToAdd, minus: 0)
        
            attributedString2 = MotifySingleEmoji("\(typeOfStringToEmoji)\u{00a0}, ", attributedString:
            attributedString2, emojiToAdd: " \(emojiToAdd)", minus: 2)
//        
//        
//        let words = attributedString.string.componentsSeparatedByString(" ")
//        
//        if(words[words.count-1] == "\(typeOfStringToEmoji)") {
//            attributedString.insertAttributedString(
//                NSMutableAttributedString(
//                    string: "\(emojiToAdd)",
//                    attributes: [String : NSObject]()),
//                    atIndex: Int("\(attributedString.string.endIndex)")!
//                )
//        }
//        
        return attributedString2
    }

        
    static func MotifySingleEmoji(typeOfStringToEmoji: String, attributedString: NSMutableAttributedString, emojiToAdd: String, minus: Int) -> NSMutableAttributedString {
        
        let inputLength = Int("\(attributedString.string.endIndex)")!
        let searchString = "\(typeOfStringToEmoji)"
        var range = NSRange(location: 0, length: Int("\(attributedString.string.endIndex)")!)
        
        while (range.location != NSNotFound) {
            
            range = (attributedString.string as NSString).rangeOfString(searchString, options: [], range: range)
            
            if (range.location != NSNotFound) {
                
                attributedString.insertAttributedString(
                    NSMutableAttributedString(
                        string: "\(emojiToAdd)",
                        attributes: [:]),
                        atIndex: range.location + range.length - minus
                    )
                
                range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
                
            }
        }
        
        return attributedString

    }
    
    static func MotifySingleNumbers(number: String, attributedString: NSMutableAttributedString, emojiToReplaceWith: String) -> NSMutableAttributedString {
        
        var range = NSRange(location: 0, length: attributedString.length)
        
        let stringToSearch = " \(number) "
        let stringToInsert = "\u{00a0}\(emojiToReplaceWith)\u{00a0}"
        
        while (range.location != NSNotFound) {
            
            range = (attributedString.string as NSString).rangeOfString(stringToSearch, options: [], range: range)
            
            if (range.location != NSNotFound) {
                
                //Add Whitespaces ad the end and in the front for Design purposes
                attributedString.mutableString.replaceOccurrencesOfString(stringToSearch, withString: stringToInsert, options: NSStringCompareOptions.CaseInsensitiveSearch, range: range)

              
                range = NSRange(location: range.location + range.length, length: Int("\(attributedString.string.endIndex)")!  - (range.location + range.length ))
                
            }
        }
        
        return attributedString
        
    }
    
}














