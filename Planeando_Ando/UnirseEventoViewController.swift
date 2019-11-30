//
//  UniverseEventoViewController.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class UnirseEventoViewController: UIViewController {

    
    var db:Firestore!
    
    var user = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
    
    @IBOutlet weak var tfCodigo: UITextField!
    
    @IBAction func btUnirseAEvento(_ sender: UIButton) {
        
        if let eventId = tfCodigo.text {
            
            db.collection("events").whereField("joinId", isEqualTo: eventId)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let document = querySnapshot!.documents.first
                        document?.reference.updateData([
                            "members": FieldValue.arrayUnion([self.user])
                        ])
                    }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func tapDismiss(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
