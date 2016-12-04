//
//  SOTSwipeControl.swift
//  SliderProject
//
//  Created by Andrea Altea on 06/06/16.
//  Copyright © 2016 Studiout. All rights reserved.
//

import UIKit

@objc public protocol SwipeControlDelegate {
    
    @objc optional func didSuccessSwipe(_ slider:SwipeControl);
    @objc optional func didCompletedSwipe(_ slider:SwipeControl);
    
}

public enum SliderStatus {
    case normal;
    case leftActive;
    case rightActive;
    case leftSuccess;
    case rightSuccess;
    case complete;
}

@IBDesignable

public class SwipeControl: UIView, UIGestureRecognizerDelegate {
    
    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    //MARK: Model
    weak public var delegate:SwipeControlDelegate?;
    
    @IBInspectable public var leftColor:UIColor = UIColor.red {
        didSet {
            leftSlider?.backgroundColor = leftColor;
        }
    }
    
    @IBInspectable public var rightColor:UIColor = UIColor.blue {
        didSet {
            rightSlider?.backgroundColor = rightColor;
        }
    }
    
    @IBInspectable public var textColor:UIColor = UIColor.lightGray {
        didSet {
            label?.textColor = textColor;
        }
    }
    
    @IBInspectable public var normalText:String = "Normal text" {
        didSet {
            if self.sliderStatus == .normal {
                self.label?.text = normalText;
            }
        }
    }
    
    @IBInspectable public var leftEnabled: Bool = true {
        didSet {
            self.leftSlider?.isHidden = !leftEnabled;
        }
    }
    
    @IBInspectable public var leftSwipeText:String = "Left Swipe text" {
        didSet {
            if self.sliderStatus == .leftActive {
                self.label?.text = leftSwipeText;
            }
        }
    }
    
    @IBInspectable public var leftSuccessText:String = "Left Completed text" {
        didSet {
            if self.sliderStatus == .leftSuccess {
                self.label?.text = leftSuccessText;
            }
        }
    }
    
    @IBInspectable public var leftImage: UIImage? {
        set {
            self.leftImageView?.image = newValue?.withRenderingMode(.alwaysTemplate);
        }
        get {
            return self.leftImageView?.image;
        }
    }
    
    @IBInspectable public var rightEnabled: Bool = true {
        didSet {
            self.rightSlider?.isHidden = !rightEnabled;
        }
    }
    
    @IBInspectable public var rightSwipeText:String = "Right Swipe text" {
        didSet {
            if self.sliderStatus == .rightActive {
                self.label?.text = rightSwipeText;
            }
        }
    }
    
    @IBInspectable public var rightSuccessText:String = "Right Completed text" {
        didSet {
            if self.sliderStatus == .rightSuccess {
                self.label?.text = rightSuccessText;
            }
        }
    }

    @IBInspectable public var rightImage: UIImage? {
        set {
            self.rightImageView?.image = newValue?.withRenderingMode(.alwaysTemplate);
        }
        get {
            return self.rightImageView?.image;
        }
    }

    @IBInspectable public var completedText:String = "Completed text"  {
        didSet {
            if self.sliderStatus == .complete {
                self.label?.text = completedText;
            }
        }
    }
    
    //MARK: lifecycle
    
    fileprivate var gestureBegan:Bool = false;
    public var isAsync:Bool = false;
    
    
    public var sliderStatus:SliderStatus = .normal {
        didSet {
            
            //Callbacks
            if let delegate = self.delegate as? NSObject {
                
                switch self.sliderStatus {
                case .rightSuccess, .leftSuccess:
                    self.isUserInteractionEnabled = false;
                    if delegate.responds(to: #selector(SwipeControlDelegate.didSuccessSwipe(_:))) {
                        delegate.perform(#selector(SwipeControlDelegate.didSuccessSwipe(_:)), with: self);
                    }
                    break;
                case .complete:
                    if delegate.responds(to: #selector(SwipeControlDelegate.didCompletedSwipe(_:))) {
                        delegate.perform(#selector(SwipeControlDelegate.didCompletedSwipe(_:)), with: self);
                    }
                    break;
                    
                    
                case .normal:
                    self.isUserInteractionEnabled = true;
                    break;
                    
                default:
                    break;
                }
                
            }
            
            
            //Animations
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .allowUserInteraction, animations: {
                
                switch self.sliderStatus {
                case .normal:
                    self.backgroundColor = UIColor.clear;
                    self.layer.borderColor = UIColor.clear.cgColor;
                    self.layer.borderWidth = 0;
                    self.leftSlider?.backgroundColor = self.leftColor;
                    self.leftSlider?.isHidden = !self.leftEnabled;
                    self.leftImageView?.tintColor = UIColor.white;
                    self.rightSlider?.backgroundColor = self.rightColor;
                    self.rightSlider?.isHidden = !self.rightEnabled;
                    self.rightImageView?.tintColor = UIColor.white;
                    self.label?.textColor = self.textColor;
                    self.label?.text = self.normalText;
                    
                    self.leftSliderPositionConstraint?.constant = 8;
                    self.rightSliderPositionConstraint?.constant = -8;
                    
                    break;
                    
                case .leftActive:
                    
                    self.backgroundColor = self.leftColor.withAlphaComponent(0.1);
                    self.layer.borderColor = self.leftColor.cgColor;
                    self.layer.borderWidth = 1;
                    self.leftSlider?.backgroundColor = UIColor.white;
                    self.leftImageView?.tintColor = self.leftColor;
                    self.rightSlider?.isHidden = true;
                    self.label?.textColor = UIColor.white;
                    self.label?.text = self.leftSwipeText;
                    break;
                    
                case .rightActive:
                    
                    self.backgroundColor = self.rightColor.withAlphaComponent(0.1);
                    self.layer.borderColor = self.rightColor.cgColor;
                    self.layer.borderWidth = 1;
                    self.rightSlider?.backgroundColor = UIColor.white;
                    self.rightImageView?.tintColor = self.rightColor;
                    self.leftSlider?.isHidden = true;
                    self.label?.textColor = UIColor.white;
                    self.label?.text = self.rightSwipeText;
                    break;
                    
                case .leftSuccess:
                    
                    if self.isAsync {
                        
                        self.leftSlider?.isHidden = true;
                        self.label?.text = self.leftSuccessText
                        
                    } else {
                        self.sliderStatus = .normal;
                    }
                    
                    break;
                    
                case .rightSuccess:
                    
                    if self.isAsync {
                        
                        self.rightSlider?.isHidden = true;
                        self.label?.text = self.rightSuccessText;
                        
                    } else {
                        self.sliderStatus = .normal;
                    }
                    
                    break;
                    
                case .complete:
                    self.label?.text = self.completedText;
                    break;
                }
                
                self.setNeedsLayout();
                
            }) { (finished) in
                
            }
        }
    }
    
    //MARK: Views
    fileprivate weak var leftImageView:UIImageView?;
    fileprivate weak var rightImageView:UIImageView?;
    weak public var label:UILabel?;
    weak public var leftSlider:UIView?;
    weak public var rightSlider:UIView?;
    
    fileprivate weak var leftSliderPositionConstraint:NSLayoutConstraint?;
    fileprivate weak var rightSliderPositionConstraint:NSLayoutConstraint?;
    
    //MARK: initialization
    
    required override public init(frame: CGRect) {
        super.init(frame:frame);
        
        setupLayout();
    }
    
    convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 360, height: 120);
        self.init(frame: frame);
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setupLayout();
    }
    
    func setupLayout() {
        
        self.backgroundColor = UIColor.white;
        
        //Add Center text
        let label = UILabel();
        label.textAlignment = .center;
        label.textColor = UIColor.lightGray;
        label.text = self.normalText;
        label.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(label);
        self.label = label;
        
        //Label constraints
        let vtConstraint = NSLayoutConstraint(item: label,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0);
        self.addConstraint(vtConstraint);
        let htConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[label]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["label" : label]);
        self.addConstraints(htConstraints);
        
        //Add Left Slider button
        let lSlider = UIView();
        lSlider.translatesAutoresizingMaskIntoConstraints = false;
        lSlider.backgroundColor = UIColor.red;
        self.addSubview(lSlider);
        self.leftSlider = lSlider;
        
        //Add Right Slider button
        let rSlider = UIView();
        rSlider.backgroundColor = UIColor.blue;
        rSlider.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(rSlider);
        self.rightSlider = rSlider;
        
        //Form factor Constaints
        let fflSlider = NSLayoutConstraint(item: lSlider, attribute: .height, relatedBy: .equal, toItem: lSlider, attribute: .width, multiplier: 1, constant: 0);
        let ffrSlider = NSLayoutConstraint(item: rSlider, attribute: .height, relatedBy: .equal, toItem: rSlider, attribute: .width, multiplier: 1, constant: 0);
        
        lSlider.addConstraint(fflSlider);
        rSlider.addConstraint(ffrSlider);
        
        //Left Slider Vertical Constraints
        let sliderViews = ["lSlider" : lSlider, "rSlider" : rSlider];
        let vlConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lSlider]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: sliderViews);
        for constraint in vlConstraints {
            constraint.priority = UILayoutPriorityDefaultLow;
        }
        let hlConstraint = NSLayoutConstraint(item: lSlider,
                                              attribute: .height,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 44);
        hlConstraint.priority = UILayoutPriorityRequired;
        let xlConstraint = NSLayoutConstraint(item: lSlider,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0);
        xlConstraint.priority = UILayoutPriorityRequired;
        
        self.addConstraints(vlConstraints);
        self.addConstraint(hlConstraint);
        self.addConstraint(xlConstraint);
        
        //Right Slider Vertical Constraints
        let vrConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[rSlider]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: sliderViews);
        for constraint in vrConstraints {
            constraint.priority = UILayoutPriorityDefaultLow;
        }
        let hrConstraint = NSLayoutConstraint(item: rSlider,
                                              attribute: .height,
                                              relatedBy: .greaterThanOrEqual,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 44);
        hrConstraint.priority = UILayoutPriorityRequired;
        let xrConstraint = NSLayoutConstraint(item: rSlider,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0);
        xrConstraint.priority = UILayoutPriorityRequired;
        
        self.addConstraints(vrConstraints);
        self.addConstraint(hrConstraint);
        self.addConstraint(xrConstraint);
        
        //Horizontal Position Constraints
        let plConstraint = NSLayoutConstraint(item: lSlider, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 8);
        let prConstraint = NSLayoutConstraint(item: rSlider, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -8);
        
        self.leftSliderPositionConstraint = plConstraint;
        self.rightSliderPositionConstraint = prConstraint;
        
        self.addConstraint(plConstraint);
        self.addConstraint(prConstraint);
        
        //Add Gestures
        let leftGesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeControl.leftGesture(_:)));
        leftGesture.minimumNumberOfTouches = 1;
        leftGesture.delaysTouchesBegan = false;
        leftGesture.delegate = self;
        let rightGesture = UIPanGestureRecognizer(target: self, action: #selector(SwipeControl.rightGesture(_:)));
        rightGesture.delegate = self;
        
        lSlider.addGestureRecognizer(leftGesture);
        rSlider.addGestureRecognizer(rightGesture);
        
        //Add Images in sliders
        let lImage = UIImageView(frame: CGRect.zero);
        lImage.backgroundColor = UIColor.clear;
        lImage.translatesAutoresizingMaskIntoConstraints = false;
        lImage.contentMode = .scaleAspectFit;
        lSlider.addSubview(lImage);
        lImage.tintColor = UIColor.white;
        self.leftImageView = lImage;
        
        let rImage = UIImageView(frame: CGRect.zero);
        rImage.backgroundColor = UIColor.clear;
        rImage.translatesAutoresizingMaskIntoConstraints = false;
        rImage.contentMode = .scaleAspectFit;
        rSlider.addSubview(rImage);
        rImage.tintColor = UIColor.white;
        self.rightImageView = rImage;
        
        let lioConstraint = NSLayoutConstraint(item: lImage,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: lSlider,
                                               attribute: .centerX,
                                               multiplier: 1,
                                               constant: 0);
        let livConstraint = NSLayoutConstraint(item: lImage,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: lSlider,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0);
        lSlider.addConstraint(lioConstraint);
        lSlider.addConstraint(livConstraint);
        
        
        let rioConstraint = NSLayoutConstraint(item: rImage,
                                               attribute: .centerX,
                                               relatedBy: .equal,
                                               toItem: rSlider,
                                               attribute: .centerX,
                                               multiplier: 1,
                                               constant: 0);
        let rivConstraint = NSLayoutConstraint(item: rImage,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                               toItem: rSlider,
                                               attribute: .centerY,
                                               multiplier: 1,
                                               constant: 0);
        rSlider.addConstraint(rioConstraint);
        rSlider.addConstraint(rivConstraint);
        
        self.setNeedsLayout();
    }
    
    //MARK: Gesture Actions
    func leftGesture(_ sender:UIPanGestureRecognizer?) {
        if let gesture = sender {
            
            let position = gesture.translation(in: self.leftSlider!);
            
            switch gesture.state {
            case .began, .possible:
                self.gestureBegan = true;
                break;
                
            case .changed:
                if (position.x > 8) && position.x <= self.frame.width - (self.leftSlider!.frame.width + 8) {
                    self.leftSliderPositionConstraint?.constant = position.x;
                    
                    self.backgroundColor = self.leftColor.withAlphaComponent(position.x / (self.frame.width / 8 * 5));
                }
                break;
                
            default:
                if position.x >= (self.frame.width / 8 * 5) {
                    //Success Left Slide
                    self.sliderStatus = .leftSuccess;
                    
                } else {
                    self.sliderStatus = .normal;
                }
                self.gestureBegan = false;
                
                break;
            }
        }
    }
    
    func rightGesture(_ sender:UIPanGestureRecognizer?) {
        if let gesture = sender {
            
            let position = gesture.translation(in: self.rightSlider!);
            
            switch gesture.state {
            case .began, .possible:
                self.gestureBegan = true;
                //self.setNeedsLayout();
                break;
                
            case .changed:
                if (position.x < -8) && position.x >= (self.leftSlider!.frame.width + 8) - self.frame.width {
                    self.rightSliderPositionConstraint?.constant = position.x;
                    
                    self.backgroundColor = self.rightColor.withAlphaComponent( -position.x / (self.frame.width / 8 * 5));
                }
                break;
                
            default:
                if position.x <= (-self.frame.width / 8 * 5) {
                    //Success Right slide
                    self.sliderStatus = .rightSuccess;
                    
                } else {
                    self.sliderStatus = .normal;
                }
                self.gestureBegan = false;
                break;
            }
        }
    }
    
    override public func layoutSubviews() {
        
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
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            if gestureRecognizer.view == self.leftSlider {
                return self.sliderStatus == .leftActive;
            } else if gestureRecognizer.view == self.rightSlider {
                return self.sliderStatus == .rightActive;
            }
        }
        return false;
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let fTouch = touches.first {
            if fTouch.view == self.leftSlider  {
                self.sliderStatus = .leftActive;
            } else if fTouch.view == self.rightSlider {
                self.sliderStatus = .rightActive;
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gestureBegan == false {
            self.sliderStatus = .normal;
        }
    }
}
