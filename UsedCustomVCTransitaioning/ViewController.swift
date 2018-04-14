//
//  ViewController.swift
//  UsedCustomVCTransitaioning
//
//  Created by leezb101 on 2018/4/14.
//  Copyright © 2018年 luohe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    var transitionAnimator: PresentAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.frame = CGRect(x: 125, y: 280, width: 200, height: 200)
        button.setNeedsLayout()
        transitionAnimator = PresentAnimator(fromFrame: button.frame)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func presentVC(_ sender: UIButton) {
        let toVC = ToViewController()
        toVC.transitioningDelegate = self
        present(toVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.presenting = false
        return transitionAnimator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.presenting = true
        return transitionAnimator
    }
}

