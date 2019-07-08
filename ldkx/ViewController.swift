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
        self.view.backgroundColor = .white
         mainTableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.view.addSubview(mainTableView)
       
        delay(0.5) {
            let indexPageNumDic = getItem("indexPageNum")
            let pathDic = getItem("indexPath")
            var section:Int = -1
            var row:Int =  -1
            var indexPageNum:Int = -1
            if pathDic.count > 0 {
                section = pathDic["section"] ?? -1
                row = pathDic["row"] ?? -1
            }
            if indexPageNumDic.count > 0 {
                indexPageNum = indexPageNumDic["indexPageNum"] ?? -1
            }
            
            if section != -1 && row != -1 && indexPageNum != -1 {
                let indexPath = IndexPath(row: row, section: section)
                statas[section] = true
                self.mainTableView.reloadData()
                self.openPageView(indexPath, indexPageNum: indexPageNum)
            }
        }
    }
    func openPageView(_ indexPath: IndexPath,indexPageNum: Int){
        setItem("indexPageNum", dic: ["indexPageNum":indexPageNum])
        let vc = ChapterShowController.shared
        vc.currentIndex = indexPageNum
        vc.fileName = (chapterInfos[indexPath.section])[indexPath.row]["titleId"] ?? ""
        if vc.chapterOprations.textChapters.count <= 0 {
            return
        }
        let nvc = UINavigationController(rootViewController: vc);
        self.present(nvc, animated: true, completion: nil)

    }
    func getTableViewPointY()->CGFloat{
        return (self.navigationController?.navigationBar.bounds.size.height ?? 44) + UIApplication.shared.statusBarFrame.size.height
    }
}

extension  ViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ChapterHeaderView(reuseIdentifier: "ChapterHeaderView")
        view.section = section;
        view.assignValue(chapters[section]["title"])
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
        setItem("indexPath", dic: ["row":indexPath.row,"section":indexPath.section])
        self.openPageView(indexPath, indexPageNum: 0)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChapterTitleCell.createChapterTitleCell(tableView: tableView)
        
        cell.titLabel.text = (chapterInfos[indexPath.section])[indexPath.row]["title"]
        if indexPath.row == (chapterInfos[indexPath.section]).count - 1 {
            cell.leftLine.frame = CGRect(x: 20, y: 0, width: 1, height: 22)
        }else{
            cell.leftLine.frame = CGRect(x: 20, y: 0, width: 1, height: 44)
        }
        return cell
    }
}

func setItem(_ key:String,dic:[String:Int]){
   let userDefault = UserDefaults.standard
    userDefault.set(dic, forKey: key)
    userDefault.synchronize()
}
func getItem(_ key:String)->[String:Int] {
    let userDefault = UserDefaults.standard
    if let dic = userDefault.value(forKey: key) as?[String:Int] {
        return dic
    }
    return [String:Int]()
}
func removeItem(_ key:String){
    let userDefault = UserDefaults.standard
    userDefault.set(nil, forKey: key)
    userDefault.synchronize()

}
