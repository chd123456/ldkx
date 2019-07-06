//
//  DragButton.swift
//  ldkx
//
//  Created by 崔海达 on 2019/7/6.
//  Copyright © 2019 Joy. All rights reserved.
//

import UIKit

protocol DragButtonDelegate {
    func dragButtonClicked(sender:UIButton)
}

class DragButton:UIButton{
    var rootView:UIView?
    var origeFrame:CGRect?
    var delegate:DragButtonDelegate?;
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.reversesTitleShadowWhenHighlighted = true
        self.setTitle("目录", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0), for: .normal)
        self.setImage(#imageLiteral(resourceName: "3d_recentBook_icon"), for: .normal)
        self.contentMode = .scaleAspectFit;
        self.addTarget(self, action: #selector(self.remove), for: .touchUpInside);
    }
    
    @objc func remove(){
       self.delegate?.dragButtonClicked(sender: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var starPos:CGPoint?
    private let ScreenW = UIScreen.main.bounds.size.width
    private let ScreenH = UIScreen.main.bounds.size.height
    enum Dir {
        case LEFT
        case RIGHT
        case TOP
        case BOTTOM
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch? = touches.first
        starPos = touch?.location(in: rootView)
        starPos = ConvertDir(p: starPos)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch? = touches.first
        var curPoint = touch?.location(in: rootView)
        curPoint = self.ConvertDir(p: curPoint)
        self.center = curPoint!;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch? = touches.first;
        var curPoint = touch?.location(in: rootView)
        curPoint = self.ConvertDir(p: curPoint)
        if(pow((starPos!.x - curPoint!.x), 2) + pow(starPos!.y - curPoint!.y, 2) < 1)
        {
            self.delegate?.dragButtonClicked(sender: self);
            return;
        }
        var W = ScreenW;
        var H = ScreenH;
        let orientation = UIApplication.shared.statusBarOrientation
        if(orientation == UIInterfaceOrientation.landscapeRight || orientation == UIInterfaceOrientation.landscapeLeft){
            W = ScreenH;
            H = ScreenW;
        }
        let left = curPoint!.x;
        let right = W - curPoint!.x;
        let top = curPoint!.y;
        let bottom = H - curPoint!.y;
        
        var minDir:Dir = .LEFT
        
        var minDistance = left;
        
        if(right < minDistance){
            minDistance = right;
            minDir = .RIGHT;
        }
        if (top < minDistance) {
            minDistance = top;
            minDir = .TOP;
        }
        if (bottom < minDistance) {
            minDir = .BOTTOM;
        }
        // 开始吸附
        switch (minDir) {
        case .LEFT:
            
            
            UIView.animate(withDuration: 0.3, animations: {
                if self.frame.origin.y < 0 {
                    self.center = CGPoint(x: self.frame.size.width/2, y: self.center.y)
                }else{
                    self.center = CGPoint(x: self.frame.size.width/2, y: self.center.y)
                    
                }
            })
            break;
            
        case .RIGHT:
            if self.frame.origin.y < 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.center = CGPoint(x: W - self.frame.size.width/2, y: self.center.y)
                })
                
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.center = CGPoint(x: W - self.frame.size.width/2, y: self.center.y)
                })
                
            }
            break;
        case .TOP:
            UIView.animate(withDuration: 0.3, animations: {
                self.center = CGPoint(x:self.center.x, y: self.frame.size.height/2)
            })
            break;
        case .BOTTOM:
            UIView.animate(withDuration: 0.3, animations: {
                self.center = CGPoint(x:self.center.x, y: H - self.frame.size.height/2)
            })
            break;
        }
        
    }
    
    // 屏幕颠倒时坐标转换
    func UpsideDown(p:CGPoint) -> CGPoint{
        return CGPoint(x: ScreenW - p.x, y: ScreenH - p.y)
    }
    // 屏幕左转时坐标转换
    
    func LandscapeLeft(p:CGPoint) -> CGPoint{
        return CGPoint(x: p.y, y: ScreenW - p.x)
    }
    // 屏幕右转时坐标转换
    func LandscapeRight(p:CGPoint) -> CGPoint{
        return CGPoint(x: ScreenH - p.y, y: p.x)
    }
    
    /**
     *  坐标转换，转换到屏幕旋转之前的坐标系中
     */
    func ConvertDir(p:CGPoint?)->CGPoint {
        // 获取屏幕方向
        
        let orientation = UIApplication.shared.statusBarOrientation
        switch (orientation) {
        case UIInterfaceOrientation.landscapeLeft:
            return self.LandscapeLeft(p: p!)
            
        case UIInterfaceOrientation.landscapeRight:
            return self.LandscapeRight(p: p!)
            
        case UIInterfaceOrientation.portraitUpsideDown:
            return self.UpsideDown(p: p!)
            
        default:
            return p!;
            
        }
    }
    
}
