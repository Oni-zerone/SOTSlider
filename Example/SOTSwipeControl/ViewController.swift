//
//  ViewController.swift
//  SliderProject
//
//  Created by Andrea Altea on 06/06/16.
//  Copyright © 2016 Studiout. All rights reserved.
//

import UIKit
import SOTSwipeControl

class ViewController: UIViewController,  SwipeControlDelegate {
    
    @IBOutlet weak var slider: SwipeControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white;
        slider.delegate = self;
        
        slider.isAsync = true;
        slider.rightEnabled = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Slide Delegate
    
    func didSuccessSwipe(_ slider: SwipeControl) {
        let alertText = slider.sliderStatus == .leftSuccess ? "Left swipe with success!" : "Right swipe with success!";
        
        let alert = UIAlertController(title: "Completed swipe with Success!", message: alertText, preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Complete!", style: .default, handler: { (action) in
            self.slider.sliderStatus = .normal;
        }));
        
        self.present(alert, animated: true) {
            //DO NOTHING.
        };
        
    }
    
}

