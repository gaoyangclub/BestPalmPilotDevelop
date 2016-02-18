//
//  ButtonAddView.swift
//  CoreGraphicsTest
//
//  Created by 高扬 on 15/9/16.
//  Copyright (c) 2015年 高扬. All rights reserved.
//  仅仅是透明度变化的按钮三态效果
//

import UIKit

class GYButton: UIButton{

    init() {
        super.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initColor();
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initColor(){
        self.backgroundColor = UIColor.clearColor()
//        self.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.Old, context: nil)
    }
    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if "state".isEqualToString(keyPath){
//            setNeedsDisplay()
//        }
//    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool{
        setNeedsLayout()
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool{
        setNeedsLayout()
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?){
        setNeedsLayout()
        super.endTrackingWithTouch(touch, withEvent: event)
    }
    override func cancelTrackingWithEvent(event: UIEvent?){
        setNeedsLayout()
        super.cancelTrackingWithEvent(event)
    }
    
    override func layoutSubviews() {
        if state == UIControlState.Normal{
            self.alpha = 1
        }else if(state == UIControlState.Highlighted){
            self.alpha = 0.65
        }else if(state == UIControlState.Selected){
            self.alpha = 0.65
        }else if(state == UIControlState.Disabled){
            self.alpha = 0.5
        }
    }

}
