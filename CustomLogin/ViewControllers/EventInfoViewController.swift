//
//  EventInfoViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 14/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController {
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var evenNameLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var name = ""
    var eventName = ""
    var dec = ""
    var location = ""
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostNameLabel.text = name
        evenNameLabel.text = eventName
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
