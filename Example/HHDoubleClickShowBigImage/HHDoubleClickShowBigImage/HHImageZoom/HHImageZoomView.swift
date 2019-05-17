//
//  HHImageZoomView.swift
//  HHDoubleClickShowBigImage
//
//  Created by Sherlock on 2018/9/10.
//  Copyright © 2018 daHuiGe. All rights reserved.
//

import UIKit

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height

class HHImageZoomView: UIView {
    
    var image:UIImage? {
        didSet{
            self.indicator.startAnimating()
            self.imageView.image = image
            self.resetSubviewSize()
            self.indicator.stopAnimating()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.backgroundColor = .black
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        self.containerView.addSubview(self.imageView)
        self.addSubview(self.indicator)
    }
    
    func resetSubviewSize() {
        var frame = CGRect.init()
        frame.origin = .zero
        guard let image = self.imageView.image else{
            return
        }
        let imageScale = image.size.height/image.size.width
        let screenScale = kHeight/kWidth
//        //宽高均小于屏幕时
//        if image.size.width <= self.bounds.width && image.size.height <= self.bounds.height {
//            frame.size.width = image.size.width
//            frame.size.height = image.size.height
//        }else{
            if imageScale > screenScale {
                frame.size.height = self.bounds.height
                frame.size.width = self.bounds.height/imageScale
            }else{
                frame.size.width = self.bounds.width
                frame.size.height = self.bounds.width*imageScale
            }
//        }
        self.scrollView.zoomScale = 1
        self.scrollView.contentSize = frame.size
        self.scrollView.scrollRectToVisible(self.bounds, animated: false)
        self.containerView.frame = frame
        self.containerView.center = self.scrollView.center
        self.imageView.frame = self.containerView.bounds
    }
    
    
    fileprivate lazy var scrollView = {() -> UIScrollView in
        var view: UIScrollView!
        view = UIScrollView()
        view.frame = self.bounds
        view.maximumZoomScale = 3.0
        view.minimumZoomScale = 1.0
        view.isMultipleTouchEnabled = true
        view.delegate = self
        view.scrollsToTop = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let doubleClick = UITapGestureRecognizer.init(target: self, action: #selector(doubleClickAction(ges:)))
        doubleClick.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleClick)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(ges:)))
        longPress.minimumPressDuration = 1.0
        view.addGestureRecognizer(longPress)
        return view
    }()
    
    fileprivate lazy var containerView = { () -> UIView in
        var view = UIView()
        return view
    }()
    
    fileprivate lazy var imageView = { () -> UIImageView in
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate lazy var indicator = { () -> UIActivityIndicatorView in
        var view = UIActivityIndicatorView.init(style: .whiteLarge)
        view.hidesWhenStopped = true
        view.center = self.center
        return view
    }()

    
    @objc func doubleClickAction(ges: UITapGestureRecognizer) {
        let scrollView = ges.view as! UIScrollView
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        }else{
            let touchPoint = ges.location(in: self.containerView)
            let newZoomScale = scrollView.maximumZoomScale
            let xsize = self.bounds.size.width / newZoomScale
            let ysize = self.bounds.size.height / newZoomScale
            scrollView.zoom(to: CGRect.init(x: touchPoint.x - xsize/2, y: touchPoint.y-ysize/2, width: xsize, height: ysize), animated: true)
        }
    }
    
    @objc func longPressAction(ges: UILongPressGestureRecognizer) {
        
    }
    
}

extension HHImageZoomView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.bounds.width > scrollView.contentSize.width ? scrollView.bounds.width - scrollView.contentSize.width : 0.0
        let offsetY = scrollView.bounds.height > scrollView.contentSize.height ? scrollView.bounds.height - scrollView.contentSize.height : 0.0
        self.containerView.center = CGPoint.init(x: (offsetX + scrollView.contentSize.width)/2, y: (offsetY + scrollView.contentSize.height)/2 )
        
    }
    
}
