//
//  EditarEventoViewController.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class EditarEventoViewController: UIViewController {

    var db:Firestore!
    
    var user = Auth.auth().currentUser?.email
    
    var Evento = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = vwVista.frame.size
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        db = Firestore.firestore()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tfNombre.text = Evento.title
        tfLugar.text = Evento.place
        tfDescripcion.text = Evento.description
        
        dpFecha.date = Evento.startTime
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vwVista: UIView!
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfLugar: UITextField!
    @IBOutlet weak var tfDescripcion: UITextField!
    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var dpHora: UIDatePicker!
    
    
    
    @IBAction func editarEvento(_ sender: Any) {
        
        if let title = tfNombre.text, let place = tfLugar.text, let description = tfDescripcion.text{
            
            let startTime  = dpFecha.date
            
            db.collection("events").whereField("joinId", isEqualTo: Evento.joinId)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let document = querySnapshot!.documents.first
                        document?.reference.setData([
                            "title":self.tfNombre.text,
                            "place":self.tfLugar.text,
                            "description":self.tfDescripcion.text,
                            "startTime":startTime
                        ], merge: true)
                    }
            }
        }
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "goToTV"){
        
        let tvcVc = segue.destination as! EventTableViewController
        
        tvcVc.modifyIndex = Evento.joinId
        }
    }
}
