//
//  LikeControl.swift
//  CustomLogin
//
//  Created by formando on 17/01/2020.
//  Copyright © 2020 formando. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

@IBDesignable class LikeControl: UIStackView {
    
    let emptyLike = UIImage(systemName: "heart")
    let fullLike = UIImage(systemName: "heart.fill")
    let button = UIButton()
    
    var userCollectionRef: CollectionReference!
    let db = Firestore.firestore()
    
    let count = UILabel()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }
    
    //MARK: Properties
    @IBInspectable var like = false
    @IBInspectable var counter = 0 {
        didSet{
            count.text = String (counter)
        }
    }
    @IBInspectable var eventName: String = ""
    
    
    //MARK: Button action
    @objc func likeButtonTapped(button: UIButton) {
        if like == false {
            //Firebase -> attribute like + 1
            like = true
            button.setImage(fullLike, for: .normal)
            db.collection("events").whereField("name", isEqualTo: eventName).getDocuments(){ (snapshot, error) in
            if let error = error{
                debugPrint("Eror se vraca")
            }else{
                guard let snap = snapshot else { return }
                           for document in snap.documents{
                                       
                            let data = document.data()
                            var like = data["likes"] as? Int ?? 0
                like = like+1
                            AppData.shared.tappedLike = like
                let document = snapshot!.documents.first?.reference.updateData(["likes":like])
                self.counter = like
                }
                
                }
            }
            
        } else {
            //Firebase -> attribute like - 1
            like = false
            //button.backgroundColor = UIColor.white
            button.setImage(emptyLike, for: .normal)
            db.collection("events").whereField("name", isEqualTo: eventName).getDocuments(){ (snapshot, error) in
            if let error = error{
                debugPrint("Eror se vraca")
            }else{
                guard let snap = snapshot else { return }
                           for document in snap.documents{
                                       
                            let data = document.data()
                            var like = data["likes"] as? Int ?? 0
                like = like-1
                let document = snapshot!.documents.first?.reference.updateData(["likes":like])
                self.counter = like
                }
                }
            }
            count.text = String( counter )
        }
    }
    
    //MARK: Private methods - Setup
    
    func setupButton(){
        
        //Getting actual like of events
        db.collection("events").whereField("name", isEqualTo: eventName).getDocuments(){ (snapshot, error) in
        if let error = error{
            debugPrint("Eror se vraca")
        }else{
            guard let snap = snapshot else { return }
                       for document in snap.documents{
                        let data = document.data()
                        var like = data["likes"] as? Int ?? 0
            }
        }
        }
        
        button.setImage(emptyLike, for: .normal)
        button.setImage(fullLike, for: .selected)
        button.setImage(fullLike, for: .highlighted)
        
        //Setting label to actual like count pull from DB
        count.text = String ( like )
        addArrangedSubview(count)
        
        //Constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        //Add button to stack
        addArrangedSubview(button)
        
        //Action
        button.addTarget(self, action: #selector(likeButtonTapped(button:)), for: .touchUpInside)
    }
    
   
    
}

