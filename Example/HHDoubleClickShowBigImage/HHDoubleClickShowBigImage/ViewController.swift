//
//  ViewController.swift
//  HHDoubleClickShowBigImage
//
//  Created by Sherlock on 2018/9/10.
//  Copyright © 2018 daHuiGe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let view = HHImageZoomView.init(frame: CGRect.init(x: 0, y: 0, width: kWidth, height: kHeight))
        view.image = UIImage.init(named: "imagelandscape.jpg")
        self.view.addSubview(view)
        
    }


}

