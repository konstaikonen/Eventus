//
//  ViewController.swift
//  CustomLogin
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        //hide the navigation bar
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide the navigation bar
        super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        
        //modify buttons
        self.signUpButton.layer.cornerRadius = 16
        //self.signUpButton.layer.borderWidth = 1
        //self.signUpButton.layer.borderColor = UIColor.blue.cgColor
        self.logInButton.layer.cornerRadius = 16
        //self.logInButton.layer.borderWidth = 1
        //self.logInButton.layer.borderColor = UIColor.blue.cgColor
       
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        
        //video background
        let theURL = Bundle.main.url(forResource:"giphy", withExtension: ".mp4")
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    
    }
   
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero)
    }

      override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
          avPlayer.play()
          paused = false
      }

      override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          avPlayer.pause()
          paused = true
      }
    
    func setUpElements(){}

}

