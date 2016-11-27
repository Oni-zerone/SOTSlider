//
//  SOTSliderControl.swift
//  SliderProject
//
//  Created by Andrea Altea on 06/06/16.
//  Copyright © 2016 Studiout. All rights reserved.
//

import UIKit

class SOTSliderControl: UIView, UIGestureRecognizerDelegate {
    
    //Model
    weak var delegate:SOTSliderControlDelegate?;
    
    var leftColor:UIColor = UIColor.redColor() {
        didSet {
            leftSlider?.backgroundColor = leftColor;
        }
    }
    var rightColor:UIColor = UIColor.blueColor() {
        didSet {
            rightSlider?.backgroundColor = rightColor;
        }
    }
    var textColor:UIColor = UIColor.lightGrayColor() {
        didSet {
            label?.textColor = textColor;
        }
    }
    
    var normalText:String = "Normal text" {
        didSet {
            if self.sliderStatus == .Normal {
                self.label?.text = normalText;
            }
        }
    }
    var leftSwipeText:String = "Left Swipe text" {
        didSet {
            if self.sliderStatus == .LeftActive {
                self.label?.text = leftSwipeText;
            }
        }
    }
    var leftSuccessText:String = "Left Completed text" {
        didSet {
            if self.sliderStatus == .LeftSuccess {
                self.label?.text = leftSuccessText;
            }
        }
    }
    var rightSwipeText:String = "Right Swipe text" {
        didSet {
            if self.sliderStatus == .RightActive {
                self.label?.text = rightSwipeText;
            }
        }
    }
    var rightSuccessText:String = "Right Completed text" {
        didSet {
            if self.sliderStatus == .RightSuccess {
                self.label?.text = rightSuccessText;
            }
        }
    }
    var completedText:String = "Completed text"  {
        didSet {
            if self.sliderStatus == .Complete {
                self.label?.text = completedText;
            }
        }
    }
    
    private var gestureBegan:Bool = false;
    var isAsync:Bool = false;
    
    
    var sliderStatus:SOTSliderStatus = .Normal {
        didSet {
            
            //CallBacks
            if let delegate = self.delegate as? NSObject {
                
                switch self.sliderStatus {
                case .RightSuccess, .LeftSuccess:
                    self.userInteractionEnabled = false;
                    if delegate.respondsToSelector(#selector(SOTSliderControlDelegate.didSuccessSwipe(_:))) {
                        delegate.performSelector(#selector(SOTSliderControlDelegate.didSuccessSwipe(_:)), withObject: self);
                    }
                    break;
                case .Complete:
                    if delegate.respondsToSelector(#selector(SOTSliderControlDelegate.didCompletedSwipe(_:))) {
                        delegate.performSelector(#selector(SOTSliderControlDelegate.didCompletedSwipe(_:)), withObject: self);
                    }
                    break;
                    
                    
                case .Normal:
                    self.userInteractionEnabled = true;
                    break;
                    
                default:
                    break;
                }
                
            }
            
            
            //Aminations
            UIView.animateWithDuration(0.4, delay: 0.0, options: .AllowUserInteraction, animations: {

                switch self.sliderStatus {
                case .Normal:
                    self.backgroundColor = UIColor.clearColor();
                    self.layer.borderColor = UIColor.clearColor().CGColor;
                    self.layer.borderWidth = 0;
                    self.leftSlider?.backgroundColor = self.leftColor;
                    self.leftSlider?.hidden = !self.leftEnabled;
                    self.leftImageView?.tintColor = UIColor.whiteColor();
                    self.rightSlider?.backgroundColor = self.rightColor;
                    self.rightSlider?.hidden = !self.rightEnabled;
                    self.rightImageView?.tintColor = UIColor.whiteColor();
                    self.label?.textColor = self.textColor;
                    self.label?.text = self.normalText;
                    
                    self.leftSliderPositionConstraint?.constant = 8;
                    self.rightSliderPositionConstraint?.constant = -8;
                    
                    break;
                    
                case .LeftActive:
                    
                    self.backgroundColor = self.leftColor.colorWithAlphaComponent(0.1);
                    self.layer.borderColor = self.leftColor.CGColor;
                    self.layer.borderWidth = 1;
                    self.leftSlider?.backgroundColor = UIColor.whiteColor();
                    self.leftImageView?.tintColor = self.leftColor;
                    self.rightSlider?.hidden = true;
                    self.label?.textColor = UIColor.whiteColor();
                    self.label?.text = self.leftSwipeText;
                    break;
                    
                case .RightActive:
                    
                    self.backgroundColor = self.rightColor.colorWithAlphaComponent(0.1);
                    self.layer.borderColor = self.rightColor.CGColor;
                    self.layer.borderWidth = 1;
                    self.rightSlider?.backgroundColor = UIColor.whiteColor();
                    self.rightImageView?.tintColor = self.rightColor;
                    self.leftSlider?.hidden = true;
                    self.label?.textColor = UIColor.whiteColor();
                    self.label?.text = self.rightSwipeText;
                    break;
                    
                case .LeftSuccess:
                    
                    if self.isAsync {
                    
                        self.leftSlider?.hidden = true;
                        self.label?.text = self.leftSuccessText
                        
                    } else {
                        self.sliderStatus = .Normal;
                    }
                    
                    break;
                    
                case .RightSuccess:
                    
                    if self.isAsync {

                        self.rightSlider?.hidden = true;
                        self.label?.text = self.rightSuccessText;
                        
                    } else {
                        self.sliderStatus = .Normal;
                    }
                    
                    break;
                    
                case .Complete:
                    self.label?.text = self.completedText;
                    break;
                }
                
                self.setNeedsLayout();

                }) { (finished) in
                    
            }
        }
    }
    
    var leftEnabled: Bool = true {
        didSet {
            self.leftSlider?.hidden = !leftEnabled;
        }
    }
    
    var rightEnabled: Bool = true {
        didSet {
            self.rightSlider?.hidden = !rightEnabled;
        }
    }
    
    //Views
    private weak var leftImageView:UIImageView?;
    private weak var rightImageView:UIImageView?;
    weak var label:UILabel?;
    weak var leftSlider:UIView?;
    weak var rightSlider:UIView?;
    
    private weak var leftSliderPositionConstraint:NSLayoutConstraint?;
    private weak var rightSliderPositionConstraint:NSLayoutConstraint?;
    
    required override init(frame: CGRect) {
        super.init(frame:frame);
        translatesAutoresizingMaskIntoConstraints = false;
        
        setupLayout();
    }
    
    convenience init() {
        let frame = CGRectMake(0, 0, 360, 120);
        self.init(frame: frame);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        translatesAutoresizingMaskIntoConstraints = false;
        
        setupLayout();
        
    }
    
    func setupLayout() {
        
        self.backgroundColor = UIColor.whiteColor();
        
        //Add Center text
        let label = UILabel();
        label.textAlignment = .Center;
        label.textColor = UIColor.lightGrayColor();
        label.text = self.normalText;
        label.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(label);
        self.label = label;
        
        //Label constraints
        let vtConstraint = NSLayoutConstraint(item: label,
                                              attribute: .CenterY,
                                              relatedBy: .Equal,
                                              toItem: self,
                                              attribute: .CenterY,
                                              multiplier: 1,
                                              constant: 0);
        self.addConstraint(vtConstraint);
        let htConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[label]|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["label" : label]);
        self.addConstraints(htConstraints);
        
        //Add Left Slider button
        let lSlider = UIView();
        lSlider.translatesAutoresizingMaskIntoConstraints = false;
        lSlider.backgroundColor = UIColor.redColor();
        self.addSubview(lSlider);
        self.leftSlider = lSlider;
        
        //Add Right Slider button
        let rSlider = UIView();
        rSlider.backgroundColor = UIColor.blueColor();
        rSlider.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(rSlider);
        self.rightSlider = rSlider;
        
        //Form factor Constaints
        let fflSlider = NSLayoutConstraint(item: lSlider, attribute: .Height, relatedBy: .Equal, toItem: lSlider, attribute: .Width, multiplier: 1, constant: 0);
        let ffrSlider = NSLayoutConstraint(item: rSlider, attribute: .Height, relatedBy: .Equal, toItem: rSlider, attribute: .Width, multiplier: 1, constant: 0);
        
        lSlider.addConstraint(fflSlider);
        rSlider.addConstraint(ffrSlider);
        
        //Left Slider Vertical Constraints
        let sliderViews = ["lSlider" : lSlider, "rSlider" : rSlider];
        let vlConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[lSlider]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: sliderViews);
        for constraint in vlConstraints {
            constraint.priority = UILayoutPriorityDefaultLow;
        }
        let hlConstraint = NSLayoutConstraint(item: lSlider,
                                              attribute: .Height,
                                              relatedBy: .GreaterThanOrEqual,
                                              toItem: nil,
                                              attribute: .NotAnAttribute,
                                              multiplier: 1,
                                              constant: 44);
        hlConstraint.priority = UILayoutPriorityRequired;
        let xlConstraint = NSLayoutConstraint(item: lSlider,
                                              attribute: .CenterY,
                                              relatedBy: .Equal,
                                              toItem: self,
                                              attribute: .CenterY,
                                              multiplier: 1,
                                              constant: 0);
        xlConstraint.priority = UILayoutPriorityRequired;
        
        self.addConstraints(vlConstraints);
        self.addConstraint(hlConstraint);
        self.addConstraint(xlConstraint);
        
        //Right Slider Vertical Constraints
        let vrConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[rSlider]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: sliderViews);
        for constraint in vrConstraints {
            constraint.priority = UILayoutPriorityDefaultLow;
        }
        let hrConstraint = NSLayoutConstraint(item: rSlider,
                                              attribute: .Height,
                                              relatedBy: .GreaterThanOrEqual,
                                              toItem: nil,
                                              attribute: .NotAnAttribute,
                                              multiplier: 1,
                                              constant: 44);
        hrConstraint.priority = UILayoutPriorityRequired;
        let xrConstraint = NSLayoutConstraint(item: rSlider,
                                              attribute: .CenterY,
                                              relatedBy: .Equal,
                                              toItem: self,
                                              attribute: .CenterY,
                                              multiplier: 1,
                                              constant: 0);
        xrConstraint.priority = UILayoutPriorityRequired;
        
        self.addConstraints(vrConstraints);
        self.addConstraint(hrConstraint);
        self.addConstraint(xrConstraint);
        
        //Horizontal Position Constraints
        let plConstraint = NSLayoutConstraint(item: lSlider, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 8);
        let prConstraint = NSLayoutConstraint(item: rSlider, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -8);
        
        self.leftSliderPositionConstraint = plConstraint;
        self.rightSliderPositionConstraint = prConstraint;
        
        self.addConstraint(plConstraint);
        self.addConstraint(prConstraint);
        
        //Add Gestures
        let leftGesture = UIPanGestureRecognizer(target: self, action: #selector(SOTSliderControl.leftGesture(_:)));
        leftGesture.minimumNumberOfTouches = 1;
        leftGesture.delaysTouchesBegan = false;
        leftGesture.delegate = self;
        let rightGesture = UIPanGestureRecognizer(target: self, action: #selector(SOTSliderControl.rightGesture(_:)));
        rightGesture.delegate = self;
        
        lSlider.addGestureRecognizer(leftGesture);
        rSlider.addGestureRecognizer(rightGesture);
        
        //Add Images in sliders
        let lImage = UIImageView(frame: CGRectZero);
        lImage.backgroundColor = UIColor.clearColor();
        lImage.translatesAutoresizingMaskIntoConstraints = false;
        lSlider.addSubview(lImage);
        lImage.tintColor = UIColor.whiteColor();
        self.leftImageView = lImage;
        
        let rImage = UIImageView(frame: CGRectZero);
        rImage.backgroundColor = UIColor.clearColor();
        rImage.translatesAutoresizingMaskIntoConstraints = false;
        rSlider.addSubview(rImage);
        rImage.tintColor = UIColor.whiteColor();
        self.rightImageView = rImage;
        
        let lioConstraint = NSLayoutConstraint(item: lImage,
                                               attribute: .CenterX,
                                               relatedBy: .Equal,
                                               toItem: lSlider,
                                               attribute: .CenterX,
                                               multiplier: 1,
                                               constant: 0);
        let livConstraint = NSLayoutConstraint(item: lImage,
                                                attribute: .CenterY,
                                                relatedBy: .Equal,
                                                toItem: lSlider,
                                                attribute: .CenterY,
                                                multiplier: 1,
                                                constant: 0);
        lSlider.addConstraint(lioConstraint);
        lSlider.addConstraint(livConstraint);
        
        
        let rioConstraint = NSLayoutConstraint(item: rImage,
                                               attribute: .CenterX,
                                               relatedBy: .Equal,
                                               toItem: rSlider,
                                               attribute: .CenterX,
                                               multiplier: 1,
                                               constant: 0);
        let rivConstraint = NSLayoutConstraint(item: rImage,
                                               attribute: .CenterY,
                                               relatedBy: .Equal,
                                               toItem: rSlider,
                                               attribute: .CenterY,
                                               multiplier: 1,
                                               constant: 0);
        rSlider.addConstraint(rioConstraint);
        rSlider.addConstraint(rivConstraint);
        
    }
    
    func setLeftImage(image: UIImage!) {
        self.leftImageView?.image = image.imageWithRenderingMode(.AlwaysTemplate);
    }
    
    func setRightImage(image: UIImage!) {
        self.rightImageView?.image = image.imageWithRenderingMode(.AlwaysTemplate);
    }

    
    //MARK: Gesture Actions
    func leftGesture(sender:UIPanGestureRecognizer?) {
        if let gesture = sender {

            let position = gesture.translationInView(self.leftSlider!);

            switch gesture.state {
            case .Began, .Possible:
                self.gestureBegan = true;
                break;
                
            case .Changed:
                if (position.x > 8) && position.x <= self.frame.width - (self.leftSlider!.frame.width + 8) {
                    self.leftSliderPositionConstraint?.constant = position.x;
                    
                    self.backgroundColor = self.leftColor.colorWithAlphaComponent(position.x / (self.frame.width / 6 * 5));
                }
                break;
                
            default:
                if position.x >= (self.frame.width / 6 * 5) {
                    //Success Left Slide
                    self.sliderStatus = .LeftSuccess;
                    
                } else {
                    self.sliderStatus = .Normal;
                }
                self.gestureBegan = false;
                
                break;
            }
        }
    }
    
    func rightGesture(sender:UIPanGestureRecognizer?) {
        if let gesture = sender {
           
            let position = gesture.translationInView(self.rightSlider!);
            
            switch gesture.state {
            case .Began, .Possible:
                self.gestureBegan = true;
                //self.setNeedsLayout();
                break;
                
            case .Changed:
                if (position.x < -8) && position.x >= (self.leftSlider!.frame.width + 8) - self.frame.width {
                    self.rightSliderPositionConstraint?.constant = position.x;
                    
                    self.backgroundColor = self.rightColor.colorWithAlphaComponent( -position.x / (self.frame.width / 6 * 5));
                }
                break;
                
            default:
                if position.x <= (-self.frame.width / 6 * 5) {
                    //Success Right slide
                    self.sliderStatus = .RightSuccess;
                    
                } else {
                    self.sliderStatus = .Normal;
                }
                self.gestureBegan = false;
                break;
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews();
        
        self.layer.cornerRadius = self.frame.height/2;
        
        if let lSlider = self.leftSlider {
            lSlider.layer.cornerRadius = lSlider.frame.height/2;
        }
        
        if let rSlider = self.rightSlider {
            rSlider.layer.cornerRadius = rSlider.frame.height/2;
        }
    }
    
    //Gesture Recognizer Delegate
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            if gestureRecognizer.view == self.leftSlider {
                return self.sliderStatus == .LeftActive;
            } else if gestureRecognizer.view == self.rightSlider {
                return self.sliderStatus == .RightActive;
            }
        }
        return false;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let fTouch = touches.first {
            if fTouch.view == self.leftSlider  {
                self.sliderStatus = .LeftActive;
            } else if fTouch.view == self.rightSlider {
                self.sliderStatus = .RightActive;
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gestureBegan == false {
            self.sliderStatus = .Normal;
        }
    }
}

@objc protocol SOTSliderControlDelegate {
    
    optional func didSuccessSwipe(slider:SOTSliderControl);
    optional func didCompletedSwipe(slider:SOTSliderControl);
    
}

enum SOTSliderStatus {
    case Normal;
    case LeftActive;
    case RightActive;
    case LeftSuccess;
    case RightSuccess;
    case Complete;
}
