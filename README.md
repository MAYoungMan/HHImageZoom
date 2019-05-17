# HHImageZoom
利用scrollView实现简单的图片预览, 双击放大、缩小处理, 代码简单易懂

核心代码:
```
//双击手势处理
if scrollView.zoomScale > 1.0 {
    scrollView.setZoomScale(1.0, animated: true)
}else{
    //根据点击的位置进行缩放
    let touchPoint = ges.location(in: self.containerView)
    let newZoomScale = scrollView.maximumZoomScale
    let xsize = self.bounds.size.width / newZoomScale
    let ysize = self.bounds.size.height / newZoomScale
    scrollView.zoom(to: CGRect.init(x: touchPoint.x - xsize/2, y: touchPoint.y-ysize/2, width: xsize, height: ysize), animated: true)
}
```
