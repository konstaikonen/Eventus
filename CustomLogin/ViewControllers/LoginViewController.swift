//
//  LoginViewController.swift
//  CustomLogin
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import AVFoundation


class LoginViewController: UIViewController {

    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var appLogo: UIImageView!
    //programmatically
    @IBOutlet var imageView: UIImageView!
    
    var jesiLoginan :Bool?
    var userCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        jesiLoginan = true
        super.viewDidLoad()
        
        setUpElements()
        
        self.loginButton.layer.cornerRadius = 4
        self.signupButton.layer.cornerRadius = 4
        emailTextField.becomeFirstResponder()
        
        //videobackground
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
              avPlayerLayer.opacity = 0.8
              view.backgroundColor = .clear
              view.layer.insertSublayer(avPlayerLayer, at: 0)
              
              NotificationCenter.default.addObserver(self,
                                                     selector: #selector(playerItemDidReachEnd(notification:)),
                                                     name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                     object: avPlayer.currentItem)

            //logo for horizontal view
        let imageName = "applicationImage.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        self.imageView = UIImageView()
        imageView.frame = CGRect(x: 400, y: -20, width: 100, height: 100)
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.imageView.isHidden = true
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {

        //hide when landscape
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
        avPlayerLayer.isHidden = true
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
            self.appLogo.isHidden = true
            self.imageView.isHidden = false

        } else {
            self.appLogo.isHidden = false
            self.imageView.isHidden = true
            view.backgroundColor = .clear
            avPlayerLayer.isHidden = false
            
           
            
        }
        
        
    }
    
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

    func setUpElements(){
        errorLabel.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginTapped(_ sender: Any) {
        setUpElements()
        //Validate text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.errorLabel.text = "Wrong Info"
                self.errorLabel.alpha = 1
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.jesiLoginan = false
            }else{
                
                self.userCollectionRef = Firestore.firestore().collection("users")
                self.userCollectionRef.getDocuments { (snapshot, error) in
                           if let error = error{
                               debugPrint("Eror se vraca")
                           }else{
                               guard let snap = snapshot else { return }
                               for document in snap.documents{
                                   
                                   let data = document.data()
                                   let firstName = data["firstname"] as? String ?? "Anonymous"
                                   let lastname = data["lastname"] as? String ?? "Anonymous"
                                   let username = data["username"] as? String ?? "Anonymous"
                                   let emailBaza = data["email"] as? String ?? "Anonymous"
                                   if email == emailBaza {
                                       AppData.shared.profileEmail = email
                                    AppData.shared.name = firstName
                                    AppData.shared.surname =  lastname
                                    self.jesiLoginan = true
                                    
                            }
                        }
                            
                    }
                }
                
            }
        
            if self.jesiLoginan == true{
                let tabBarViewController = self.storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
                
                AppData.shared.profileEmail = email
                
                self.view.window?.rootViewController = tabBarViewController
                self.view.window?.makeKeyAndVisible()
                
            }else{
                self.errorLabel.text = "Wrong Info"
                self.jesiLoginan = true
                
            }
                
                
                
                //self.performSegue(withIdentifier: "loginToProfile", sender: self)
                
            }
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
}
    


