//
//  ChapterTextViewController.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/3.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ChapterTextViewController: UIViewController,AVSpeechSynthesizerDelegate,YYTextViewDelegate, YYTextKeyboardObserver {
    var textView: YYTextView? = nil
    var firstInitFlag:CGFloat = 0
    var textString:String = ""
    var num = "1/1"
    let pageNumlabel:UILabel = UILabel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = UIColor(red: 152/255.0, green: 188/255.0, blue: 159/255.0, alpha: 1.0)
        initUI()
        if self.textView == nil {
           createTextView(false)
        }
    }
    func initUI(){
        pageNumlabel.font = UIFont.systemFont(ofSize: 12);
        pageNumlabel.textColor = UIColor.black
        pageNumlabel.text = num
        pageNumlabel.textAlignment = .left
        self.view.addSubview(pageNumlabel)
        let x = self.view.bounds.size.width - 60
        let y = self.view.bounds.size.height - 40
        pageNumlabel.frame = CGRect(x: x, y: y, width: 100, height: 30)
    }
    

    func createTextView(_ vertical: Bool){
        initTextView(vertical)
    }
    
    
    func initTextView(_ vertical: Bool){
        if textView != nil {
            textView?.removeFromSuperview()
            textView = nil
        }
        let text:NSMutableAttributedString = NSMutableAttributedString(string: self.textString)
        text.yy_font = UIFont.init(name: "Times New Roman", size: 20)
        text.yy_lineSpacing = 4;
        text.yy_kern = 4
        text.yy_paragraphSpacing = 10
        text.yy_paragraphSpacingBefore = 10
        text.yy_firstLineHeadIndent = 20;
        self.textView = YYTextView();
        
        textView?.size = self.view.size;
        let topPointY:CGFloat = isIphoneXSerial() ? 50 : 30
        let top:CGFloat = topPointY - firstInitFlag;
        textView?.textContainerInset = UIEdgeInsets(top: top, left: 10, bottom: 30, right: 10);
        textView?.delegate = self;
        textView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0);
        textView?.scrollIndicatorInsets = textView!.contentInset;
        textView?.selectedRange = NSMakeRange(text.length, 0);
        textView?.isEditable = false
        self.textView?.isVerticalForm = vertical
        textView?.attributedText = text;
        self.view.addSubview(textView!)

    }

}
