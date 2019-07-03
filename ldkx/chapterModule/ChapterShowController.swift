//
//  ChapterShowController.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/2.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ChapterShowController: UIViewController,UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    let pageVC:UIPageViewController = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.pageCurl, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: [UIPageViewController.OptionsKey.spineLocation:UIPageViewController.SpineLocation.min])
    let currentIndex:NSInteger = 0
    let nextIndex:NSInteger = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil;
    }

}
