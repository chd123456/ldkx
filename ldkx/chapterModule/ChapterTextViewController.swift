//
//  ChapterTextViewController.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/3.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ChapterTextViewController: UIViewController,YYTextViewDelegate, YYTextKeyboardObserver {
    var textView: YYTextView? = nil
    var firstInitFlag:CGFloat = 0
    var textString:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = UIColor(red: 152/255.0, green: 188/255.0, blue: 159/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.textView == nil {
            initTextView()
        }
    }
    
    func initTextView(){
        let text:NSMutableAttributedString = NSMutableAttributedString(string: self.textString)
        text.yy_font = UIFont.init(name: "Times New Roman", size: 20)
        text.yy_lineSpacing = 4;
        text.yy_kern = 4
        text.yy_paragraphSpacing = 10
        text.yy_paragraphSpacingBefore = 10
        text.yy_firstLineHeadIndent = 20;
        self.textView = YYTextView();
        textView?.attributedText = text;
        textView?.size = self.view.size;
        let topPointY:CGFloat = isIphoneXSerial() ? 50 : 30
        let top:CGFloat = topPointY - firstInitFlag;
        textView?.textContainerInset = UIEdgeInsets(top: top, left: 10, bottom: 10, right: 10);
        textView?.delegate = self;
        textView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        textView?.scrollIndicatorInsets = textView!.contentInset;
        textView?.selectedRange = NSMakeRange(text.length, 0);
        textView?.isEditable = false
        self.view.addSubview(textView!)

    }

}
