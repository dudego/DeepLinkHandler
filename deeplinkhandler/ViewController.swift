//
//  ViewController.swift
//  deeplinkhandler
//
//  Created by Sahil Dudeja on 5/1/17.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CachingManager.shared.model != nil {
            label.text = CachingManager.shared.model?.toString()
        } else {
            label.text = "DeepLink Model is null"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class CachingManager {
    static let shared = CachingManager()
    var model : DeepLinkModel?
    //    var notificationSettings: [String: Any]?
}

