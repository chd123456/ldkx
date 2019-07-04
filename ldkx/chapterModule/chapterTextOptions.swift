//
//  chapterTextOptions.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/3.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class chapterTextOptions: NSObject {
    var fileName:String = "" {
        didSet{
            let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") ?? ""
            if let bookData = try? NSData(contentsOfFile: filePath, options: .mappedIfSafe) {
                if let bookContent = NSString(data: bookData as Data, encoding: String.Encoding.utf8.rawValue){
                    self.subViewControllers = creatSubViewControllers(bookContent)
                }
                
            }

        }
    }
    var subViewControllers = [ChapterTextViewController]()
    func creatSubViewControllers(_ text:NSString) -> [ChapterTextViewController] {
        var array = [ChapterTextViewController]()
        let countOne = getCharsCountForOnePage()
        let countAll = text.length
        var pageNum = countAll / countOne
        if countAll % countOne > 0 {
            pageNum += 1;
        }
        for i in (0..<pageNum){
            let subVC = ChapterTextViewController()
            subVC.textString = getSomePointString(text, index: i, range: countOne)
            array.append(subVC)
        }
        return array
    }
    
    func getSomePointString(_ text:NSString,index:Int,range:Int)->String{
        let location = range * index
        let length = (range * (index + 1) > text.length) ? text.length - location : range
        let range = NSRange(location: location, length: length)
        
        return text.substring(with: range)
    }
    
    func getCharsCountForOnePage()->Int{
        let size = UIScreen.main.bounds.size
        let w = size.width - 20;
        let y = size.height - 30 - 50;
        let areaOneWord:CGFloat = 24 * 30;
        let count =  Int(w * y / areaOneWord) - 30
        return count;
    }
    
    func viewControllerAtIndex(_ index:NSInteger) -> ChapterTextViewController? {
        return self.subViewControllers[index]
    }
}
