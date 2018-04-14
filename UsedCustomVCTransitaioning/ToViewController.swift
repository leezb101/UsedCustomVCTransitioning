//
//  ToViewController.swift
//  UsedCustomVCTransitaioning
//
//  Created by leezb101 on 2018/4/14.
//  Copyright © 2018年 luohe. All rights reserved.
//

import UIKit

class ToViewController: UIViewController {

    lazy var dismissButton: UIButton = {
        let result = UIButton(type: .system)
        result.setTitle("回到过去", for: .normal)
        result.backgroundColor = .yellow
        result.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        result.addTarget(self, action: #selector(dismissVC(sender:)), for: .touchUpInside)
        self.view.addSubview(result)
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        dismissButton.frame = CGRect(x: view.frame.midX - 50, y: view.frame.midY - 20, width: 100, height: 40)
        // Do any additional setup after loading the view.
    }

    @objc func dismissVC(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
