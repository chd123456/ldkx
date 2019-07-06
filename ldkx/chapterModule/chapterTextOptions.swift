//
//  chapterTextOptions.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/3.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class chapterTextOptions: NSObject {
    var numberLinesForOnePage:NSInteger = 0
    var fileName:String = "" {
        didSet{
            let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") ?? ""
            if let bookData = try? NSData(contentsOfFile: filePath, options: .mappedIfSafe) {
                if let bookContent = NSString(data: bookData as Data, encoding: String.Encoding.utf8.rawValue){
                    let arr = bookContent.components(separatedBy: "\n")
                    var totalLines = 0
                    let oneLineChars = getCharsCountForOneLine()
                     numberLinesForOnePage = getNumberLinesForPage()
                    for (_,s) in arr.enumerated() {
                        var currentLines = (s.count / oneLineChars)
                        let restChars = s.count % oneLineChars
                        if restChars > 0 {
                            currentLines += 1
                        }
                        totalLines += currentLines
                        var location = 0
                        let length = oneLineChars
                        for j in (0..<currentLines){
                            if (currentLines - 1 == j) && (restChars > 0) {
                                let subRange = NSRange(location: location, length: restChars)
                                let subString = (s as NSString).substring(with: subRange)
                                textLines.append(subString as NSString)
                                textLines.append("\n" as NSString)
                            }else{
                                let subRange = NSRange(location: location, length: length)
                                let subString = (s as NSString).substring(with: subRange)
                                textLines.append(subString as NSString)
                                location = length * (j + 1)
                            }
                            
                        }
                    }

                    self.textChapters = creatTextChapters()
                }
                
            }

        }
    }
    var textChapters = [String]()
    var textLines = [NSString]()
    func creatTextChapters() -> [String] {
        var array = [String]()
        let countOne = getNumberLinesForPage()
        let countAll = textLines.count
        var pageNum = countAll / countOne
        if countAll % countOne > 0 {
            pageNum += 1;
        }
        for i in (0..<pageNum){
            let textString = getSomePointString(i)
            array.append(textString)
        }
        return array
    }
    
    func getSomePointString(_ index:Int)->String{
    
        
        let location = numberLinesForOnePage * index
        let endIndex = location + numberLinesForOnePage
        let numberLines = textLines.count / numberLinesForOnePage
        let lastLines = textLines.count % numberLinesForOnePage
       
        var subString = ""
        if index == numberLines && lastLines > 0 {
            for k in (location ..< (location + lastLines)){
                subString += (textLines[k] as String)
            }
        }else{
            for k in (location ..< endIndex){
                subString += (textLines[k] as String)
            }
        }
        return subString
        
    }
    
    func getCharsCountForOnePage()->Int{
        let size = UIScreen.main.bounds.size
        let w = size.width - 20;
        let offsetY:CGFloat = isIphoneXSerial() ? 120 : 70
        let h = size.height - 30 - offsetY;
        let areaOneWord:CGFloat = 24 * 30;
        let count =  Int(w * h / areaOneWord) - 30
        return count;
    }
    
    func getCharsCountForOneLine()->Int{
        let size = UIScreen.main.bounds.size
        let w = size.width - 20;
        let areaOneWord:CGFloat = 24;
        let count =  Int(w / areaOneWord)
        return count;
    }
    
    func getNumberLinesForPage()->Int{
        let size = UIScreen.main.bounds.size
        let offsetY:CGFloat = isIphoneXSerial() ? 180 : 70
        let h = size.height - 30 - offsetY;
        let onelineHeight:CGFloat = 30;
        let count =  Int(h / onelineHeight)
        return count;
    }

    
    func viewControllerAtIndex(_ index:NSInteger) -> ChapterTextViewController? {
        let subVC = ChapterTextViewController()
        subVC.num = "\(index+1) / \(textChapters.count)"
        subVC.textString = textChapters[index]
        return subVC
    }
}

func isIphoneXSerial()->Bool{
   let b1 = UIScreen.main.bounds.size.height == 896
   let b2 = UIScreen.main.bounds.size.height == 812
   return b1 || b2
}
