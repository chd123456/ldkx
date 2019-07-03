//
//  ChapterTitleCell.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/2.
//  Copyright © 2019 Joy. All rights reserved.
//

import Foundation
import UIKit
class ChapterTitleCell:UITableViewCell {
    let topLine = UIView()
    let leftLine = UIView()
    let centerLine = UIView()
    let titLabel = UILabel()
    
    
    static func createChapterTitleCell(tableView: UITableView) -> ChapterTitleCell{
        
        let cellID = "ChapterTitleCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = ChapterTitleCell.init(style: .default, reuseIdentifier: cellID)
        }
        
        return cell as! ChapterTitleCell
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        initWithProperty()
        setConstraints()
    }
    
    
    func setConstraints(){
        self.contentView.addSubview(titLabel);
        self.contentView.addSubview(topLine);
        self.contentView.addSubview(leftLine);
        self.contentView.addSubview(centerLine);
        titLabel.frame = CGRect(x: 40, y: 0, width: UIScreen.main.bounds.size.width - 90, height: 44)
        topLine.frame = CGRect(x: 40, y: 0, width: UIScreen.main.bounds.size.width - 20, height: 1)
        leftLine.frame = CGRect(x: 20, y: 0, width: 1, height: 44)
        centerLine.frame = CGRect(x: 20, y: 22, width: 10, height: 1)

    }
    
    func initWithProperty(){
        titLabel.textColor = UIColor.black
        titLabel.font = UIFont.systemFont(ofSize: 16)
        titLabel.numberOfLines = 2;
        titLabel.textAlignment = NSTextAlignment.left
        titLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        topLine.backgroundColor = UIColor.init(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        leftLine.backgroundColor = UIColor.black
        centerLine.backgroundColor = UIColor.black
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
