//
//  Informacion_ViewController.swift
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class newEventViewController: UIViewController {

    var db:Firestore!
    
    var user = Auth.auth().currentUser?.email
    
    var prueba:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = vwVista.frame.size
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        db = Firestore.firestore()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        obtenerEventoId()
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vwVista: UIView!
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfLugar: UITextField!
    @IBOutlet weak var tfDescripcion: UITextField!
    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var dpHora: UIDatePicker!
    
    
    
    @IBAction func crearEvento(_ sender: Any) {
        
        if let title = tfNombre.text, let place = tfLugar.text, let description = tfDescripcion.text{
            
            let startTime  = dpFecha.date
            
            let joinId = prueba
             
            let newEvent = Event(title: title, description: description, startTime: startTime, place: place, status: "Activo", joinId:joinId, members: [user!],docRef: "")
        
                   
                   var ref:DocumentReference? = nil
                   ref = db.collection("events").addDocument(data: newEvent.dictionary) {
                       error in
                       
                       if let error = error {
                           print("Error adding document: \(error.localizedDescription)")
                       }else{
                           print("Document added with ID: \(ref!.documentID)")
                            self.db.collection("events").document(String(ref!.documentID)).setData([ "docRef": String(ref!.documentID)], merge: true)
                       }
                       
                   }
        }
    }
    
    func obtenerEventoId(){
        
        var lastID: String?
        let myURL = NSURL(string:"https://us-central1-planeando-ando.cloudfunctions.net/generateUserId");

        let request = NSMutableURLRequest(url:myURL! as URL);
        //request.httpMethod = "GET" // This line is not need
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            // Check for error
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }

            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            lastID = "\(responseString!)"
            self.prueba = lastID!
        }

        task.resume()
        
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
}

