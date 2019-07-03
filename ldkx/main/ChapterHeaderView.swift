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
    
    var section = -1;
    let titleLabel = UILabel()
    let button = UIButton()
    let imageView = UIImageView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        initWithProperty()
        setConstraints()
    }
    
    func assignValue(_ titleText: String?){
        titleLabel.text = titleText;
        if statas[section] {
            imageView.image = UIImage.init(named: "showMoreBtnTop")
        }else{
            imageView.image = UIImage.init(named: "showMoreBtn")
        }
    }
    
    func initWithProperty(){
        titleLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.addTarget(self, action: #selector(self.headerViewClick(sender:)), for: UIControl.Event.touchUpInside)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit;
        imageView.image = UIImage.init(named: "showMoreBtn")
    }
    
    @objc func headerViewClick(sender:UIButton){
        statas[section] = !statas[section]
        if statas[section] {
            imageView.image = UIImage.init(named: "showMoreBtnTop")
        }else{
            imageView.image = UIImage.init(named: "showMoreBtn")
        }
        
        if let tableview = self.superview as?UITableView{
            tableview.reloadData()
        }
    }
    
    func setConstraints(){
        self.contentView.addSubview(titleLabel);
        self.contentView.addSubview(button)
        titleLabel.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width - 70, height: 50)
        self.contentView.addSubview(imageView)
        imageView.frame = CGRect(x: UIScreen.main.bounds.size.width - 30, y: 20, width: 15, height: 15)

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

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}
