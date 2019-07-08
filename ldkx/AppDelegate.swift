//
//  AppDelegate.swift
//  lingdao
//
//  Created by 崔海达 on 2019/7/1.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if window == nil {
            window = UIWindow.init(frame: UIScreen.main.bounds)
        }
        
        let vc = ViewController()
        let nvc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nvc
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        postNotification(name: NoticeName.applicationDidEnterBackground.rawValue, infos: nil)
    }

}

enum NoticeName:String {
    case applicationDidEnterBackground = "applicationDidEnterBackground"
}

func registerNotification(observer:Any,selector:Selector,name:String,object:Any? = nil){
    NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(name), object: object)
}

func removeNotification(observer:Any,selector:Selector,name:String,object:Any? = nil){
    NotificationCenter.default.removeObserver(observer, name: Notification.Name(name), object: object)
}

func postNotification(name:String,infos:[String : String]?){
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: infos)
}

