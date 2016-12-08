//
//  ViewController.swift
//  NotifyButton
//
//  Created by Tony M Joseph on 12/08/2016.
//  Copyright (c) 2016 Tony M Joseph. All rights reserved.
//

import UIKit
import NotifyButton

class ViewController: UIViewController,NotifyButtonDelegate {

    @IBOutlet weak var notifyMeButton: NotifyButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        notifyMeButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishTask(sender: String, button: NotifyButton) {
        // do task using the email
        button.success()  // if success
    }

}

