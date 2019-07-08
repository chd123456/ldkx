//
//  ChapterShowController.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/2.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

class ChapterShowController: UIViewController,UIPageViewControllerDataSource , UIPageViewControllerDelegate,DragButtonDelegate,UIGestureRecognizerDelegate,AVSpeechSynthesizerDelegate{
    static let shared = ChapterShowController()
    var pageController:UIPageViewController?
    var currentIndex:NSInteger = 0
    let nextIndex:NSInteger = 0
    var chapterOprations:chapterTextOptions!
    var pageIsAnimating = true
    var voice:AVSpeechSynthesizer!
    var speech:AVSpeechUtterance?
    var speechButton:UIButton!
    lazy var dragActivityFloatButton: DragButton = {
        
        let button = DragButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.delegate = self;
        return button
    }()
    var fileName:String = "" {
        didSet{
            
            initPageViewController()
            if currentIndex == 0 {
                speekerBtn(self.chapterOprations.bookContentString)
            }else{
                speakerOprations()
            }
            
            self.view.addSubview(dragActivityFloatButton)
            dragActivityFloatButton.frame =  CGRect(x: 0, y: self.view.frame.size.height - 50, width: 100, height: 50)
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance){
        voice.stopSpeaking(at: .immediate)
        speechButton.isSelected = false
    }
    

    func speakerOprations(){
        let length = self.chapterOprations.textChapters.count
        var speakerTxt = ""
        for i in currentIndex..<length {
            speakerTxt += self.chapterOprations.textChapters[i]
        }
        speech = AVSpeechUtterance(string: speakerTxt)
        speech?.pitchMultiplier = 1 //[0.5-2.0]
        speech?.volume = 1 //[0-1]
        speech?.rate = 0.5//[0-1]
        let language = AVSpeechSynthesisVoice(language: "zh-CN")
        speech?.voice  = language
    }
    
    func speekerBtn(_ speakContentText:String){
        voice = AVSpeechSynthesizer()
        voice.delegate = self
        speechButton = UIButton()
        speechButton.setTitle("听👂", for: .normal)
        speechButton.setTitle("停⏹", for: .selected)
        speechButton.setTitleColor(UIColor.yellow, for: .normal)
        speechButton.setTitleColor(UIColor.darkGray, for: .selected)
        speechButton.titleLabel?.font = UIFont.systemFont(ofSize: 24);
        self.view.addSubview(speechButton)

        speechButton.frame = CGRect(x: self.view.frame.size.width - 200, y: self.view.frame.size.height - 50, width: 100, height: 50)
            
        speechButton.addTarget(self, action: #selector(self.speech(_:)), for: .touchUpInside)
        
        speech = AVSpeechUtterance(string: speakContentText)
        speech?.pitchMultiplier = 1 //[0.5-2.0]
        speech?.volume = 1 //[0-1]
        speech?.rate = 0.5//[0-1]
        let language = AVSpeechSynthesisVoice(language: "zh-CN")
        speech?.voice  = language

    }
    
    @objc func speech(_ sender: UIButton){
         speakerOprations()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            //听
            if let s = speech {
                if !voice.continueSpeaking() {
                     voice.speak(s)
                }
            }
        }else{
            voice.pauseSpeaking(at: .word)
            //停
        }
    }

    
    func dragButtonClicked(sender: UIButton) {
        dragActivityFloatButton.removeFromSuperview()
        removeItem("indexPageNum")
        self.parent?.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if voice != nil && voice.isSpeaking {
            voice.stopSpeaking(at: .immediate)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
        registerNotification(observer: self, selector: #selector(self.saveCurrentIndex), name: NoticeName.applicationDidEnterBackground.rawValue)
    }
    
   @objc func saveCurrentIndex(){
        if self.navigationController != nil {
           setItem("indexPageNum", dic: ["indexPageNum":currentIndex])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func initNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    func initPageViewController(){
        self.chapterOprations = chapterTextOptions()
        chapterOprations.fileName = fileName
        self.pageController = UIPageViewController.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation:NSNumber(value:UIPageViewController.SpineLocation.min.rawValue)])
           self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y:0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChild(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController?.didMove(toParent: self)
        
        if self.chapterOprations.textChapters.count <= 0 {
            return
        }
        let dataVC = self.chapterOprations.viewControllerAtIndex(self.currentIndex)!
        dataVC.firstInitFlag = 20
        self.pageController?.setViewControllers([dataVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: { (b) in
            
            for gesRecog in self.pageController?.gestureRecognizers ?? [UIGestureRecognizer]()
            {
                if gesRecog.isKind(of: UITapGestureRecognizer.self) {
                    gesRecog.isEnabled = false;
                }else if gesRecog.isKind(of: UIPanGestureRecognizer.self) {
                    gesRecog.delegate = self;
                }
            }

        })
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && (gestureRecognizer.view!.isEqual(self.view) || gestureRecognizer.view!.isEqual(self.pageController?.view)))
        {
            let panGes:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer;
            let X = panGes.velocity(in: self.pageController?.view).x

            if(!pageIsAnimating || (self.currentIndex - 1 < 0 && X > 0) || (self.currentIndex + 1 > self.chapterOprations.textChapters.count - 1 && X < 0)){
                return false
            }
        
            pageIsAnimating = false;
        }
        return true;

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageIsAnimating = true;
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
     
        self.currentIndex -= 1
        if self.currentIndex < 0  {
            self.currentIndex += 1;
            return nil
        }
        return self.chapterOprations.viewControllerAtIndex(self.currentIndex)

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.currentIndex += 1
        if self.currentIndex > self.chapterOprations.textChapters.count - 1  {
            self.currentIndex -= 1;
            return nil
        }
        return self.chapterOprations.viewControllerAtIndex(self.currentIndex)
    }

}
