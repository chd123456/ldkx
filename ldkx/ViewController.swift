//
//  ViewController.swift
//  lingdao
//
//  Created by 崔海达 on 2019/7/1.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sction:Int = 0
    //基本的view
    lazy var mainTableView: UITableView = {
        
        let mainTableView = UITableView(frame: CGRect.zero, style: .grouped)
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.estimatedRowHeight = 200
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.separatorStyle = .none
        
        return mainTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "领导科学"
        self.view.addSubview(mainTableView)
        statas[0] = true;
        mainTableView.frame = self.view.frame;
    }
}

extension  ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ChapterHeaderView(reuseIdentifier: "ChapterHeaderView")
        view.assignValue(chapters[section]["title"])
        view.section = section;
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
//        view.backgroundColor = uicolorf5
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statas[section] {
            return (chapterInfos[section]).count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chapters.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView(tableView, didDeselectRowAt: indexPath);
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cellId")
        if indexPath.section == 0{
            cell.textLabel?.text = (chapterInfos[indexPath.section])[indexPath.row]["title"]
        }else{
            cell.textLabel?.text = "121212"

        }
        return cell
    }
}
