//
//  ViewController.swift
//  firebase-network-bug-reproduce
//
//  Created by Rotem Yakir on 22/01/2018.
//  Copyright © 2018 Guggy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    
    @IBOutlet weak var textbox: UITextView!
    
    var db:Firestore {
        
        get {
            
            return Firestore.firestore()
            
        }
        
    }
    
    static func randomString(_ length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    @IBAction func doIt(_ sender: Any) {
        
        let batch = db.batch()

        let messagesRef: DocumentReference = db.collection("messages").document()

        var data = [String:Any]()
        
        data["text"] = ViewController.randomString(8) as Any
        
        batch.setData(data, forDocument: messagesRef)

        let d = Date()
        
        textbox.text.append(contentsOf: "Saving message id \(messagesRef.documentID) \n")
        
        batch.commit { [unowned self] err in
            
            self.textbox.text.append(contentsOf: "Complete after \( String(format: "%.2f", (Date().timeIntervalSince1970 - d.timeIntervalSince1970))) milliseconds \n")

            guard err == nil else {
                
                self.textbox.text.append(contentsOf: "Error \(err.debugDescription) \n")
               
                return
                
            }
            
            //self.textbox.text.append(contentsOf: "Great success \n")

            print("Done")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will cause the
        self.db.collection("messages").getDocuments { (snapshot, err) in
            
            print("Fetched")
            
        }
        
    }

}

