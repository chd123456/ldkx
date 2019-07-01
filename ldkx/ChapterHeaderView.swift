//
//  ChapterHeaderView.swift
//  MJLottery
//
//  Created by 崔海达 on 2018/9/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import Foundation
import UIKit
class ChapterHeaderView: UITableViewHeaderFooterView{
    
    var section = 0;
    let titleLabel = UILabel()
    let button = UIButton()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        initWithProperty()
        setConstraints()
    }
    
    func assignValue(_ titleText: String?){
        titleLabel.text = titleText;
    }
    
    func initWithProperty(){
        titleLabel.textColor = UIColor.black
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.addTarget(self, action: #selector(self.headerViewClick(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func headerViewClick(sender:UIButton){
        statas[section] = !statas[section]
        if let tableview = self.superview as?UITableView{
            tableview.reloadData()
        }
    }
    
    func setConstraints(){
        self.contentView.addSubview(titleLabel);
        self.contentView.addSubview(button)
        titleLabel.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 50)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//#MARK: 实现视图的旋转
func rotationAnim(view:UIView,duration:TimeInterval,value:Double){
    UIView.animate(withDuration: duration) {
        var transform = view.transform
        transform = transform.rotated(by: CGFloat(value))
        view.transform = transform
    }
    
}
