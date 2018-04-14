//
//  KRPresentAnimeTransition.swift
//  KaraComponent
//
//  Created by leezb101 on 2018/1/26.
//

import UIKit

public class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    public static var snapShotImage: UIImage?
    
    private enum playOrient {
        case horizon, vertical
    }
    
    /// 动画duration
    let duration = 0.8
    
    public var initialFrame: CGRect
    
    public var presenting = true //当前是否在presenting
    
    public init(fromFrame: CGRect?) {
        if let fromFrame = fromFrame {
            self.initialFrame = fromFrame
        } else {
            self.initialFrame = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 1, height: 1)
        }
        super.init()
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        var detailView: UIView
        // 计算initialFrame的横竖屏问题
        // 首先，以下处理均适用于dismiss
        if !presenting {
            // 判断类变量中是否存在截图，如不存在，直接使用当前fromView作为动画素材
            if let image = PresentAnimator.snapShotImage {
                let orient: playOrient = initialFrame.width >= initialFrame.height ? .horizon : .vertical
                // 根据横竖屏确定实际播放时播放框的frame
                var realRatio: CGFloat
                switch orient {
                case .horizon:
                    realRatio = UIScreen.main.bounds.width / initialFrame.width
                case .vertical:
                    realRatio = UIScreen.main.bounds.height / initialFrame.height
                }
                let realSize = CGSize(width: initialFrame.width * realRatio, height: initialFrame.height * realRatio)
                let realOrigin = CGPoint(x: UIScreen.main.bounds.midX - realSize.width / 2.0, y: UIScreen.main.bounds.midY - realSize.height / 2.0)
                let realRect = CGRect(origin: realOrigin, size: realSize)
                let imageView = UIImageView(frame: realRect)
                imageView.image = image
                detailView = imageView
                // 通过计算创建出所用的view后，将其加入当前动画上下文中，同时将原有fromView移除
                containerView.addSubview(detailView)
                fromView.removeFromSuperview()
            } else {
                detailView = fromView
            }
        } else {
            detailView = toView
        }
        
        let fromFrame = presenting ? initialFrame : detailView.frame
        let finalFrame = presenting ? detailView.frame : initialFrame
        
        let xScaleFactor = presenting ? fromFrame.width / finalFrame.width : finalFrame.width / fromFrame.width
        let yScaleFactor = presenting ? fromFrame.height / finalFrame.height : finalFrame.height / fromFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(x: fromFrame.midX, y: fromFrame.midY)
            detailView.clipsToBounds = true
            detailView.alpha = 0
        } else {
            // 动画效果为，从原始大小缩放到之前记录的frame
            detailView.transform = .identity
            detailView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            detailView.clipsToBounds = true
        }
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: detailView)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            detailView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            detailView.alpha = 1
        }) { (complished) in
            // 动画完成后，清除当前类变量中的截图信息，防制以后其他类调用该动画时出现流程串线
            PresentAnimator.snapShotImage = nil
            transitionContext.completeTransition(true)
        }
    }
    
}



