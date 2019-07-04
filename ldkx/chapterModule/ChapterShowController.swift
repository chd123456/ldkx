//
//  ChapterShowController.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/2.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ChapterShowController: UIViewController,UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    var pageController:UIPageViewController?
    var currentIndex:NSInteger = 0
    let nextIndex:NSInteger = 0
    let chapterOprations = chapterTextOptions()
    var fileName:String = "" {
        didSet{
            initPageViewController()
            if self.chapterOprations.subViewControllers.count <= 0 {
                return
            }
            let dataVC = self.chapterOprations.subViewControllers[0]
            dataVC.firstInitFlag = 0
            self.pageController?.setViewControllers([dataVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: { (b) in
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func initNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func initPageViewController(){
        chapterOprations.fileName = fileName
        self.pageController = UIPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation:NSNumber(value:UIPageViewController.SpineLocation.min.rawValue)])
           self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y:0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController?.didMove(toParent: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.currentIndex -= 1
        if self.currentIndex < 0  {
            self.currentIndex += 1;
            return nil
        }
        return self.chapterOprations.subViewControllers[currentIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.currentIndex += 1
        if self.currentIndex > self.chapterOprations.subViewControllers.count - 1  {
            self.currentIndex -= 1;
            self.navigationController?.dismiss(animated: true, completion: nil)
            return nil
        }
        return self.chapterOprations.subViewControllers[currentIndex]
    }

}
