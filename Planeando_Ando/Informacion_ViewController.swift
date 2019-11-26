//
//  Informacion_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 11/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class Informacion_ViewController: UIViewController {

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
            
            let startTime  = obtenerFecha()
            
            let joinId = prueba
             
            let newEvent = Event(title: title, description: description, startTime: startTime, place: place, status: "Activo", joinId:joinId, members: [user!])
                   
                   var ref:DocumentReference? = nil
                   ref = db.collection("events").addDocument(data: newEvent.dictionary) {
                       error in
                       
                       if let error = error {
                           print("Error adding document: \(error.localizedDescription)")
                       }else{
                           print("Document added with ID: \(ref!.documentID)")
                       }
                       
                   }
        }
    }
    
    func obtenerFecha() -> Date{
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        //let someDateTime = formatter.date(from: "2016/10/08 22:31")
        
        //var stringf = formatter.date(from: dpFecha.)
        let calendar = Calendar.current
        //let datecomponent = DateComponents(calendar: calendar,year: dpFecha!.date, month: dpFecha!.date, day: dpFecha!.date)
        let año = calendar.component(.year, from: dpFecha.date)
        let mes = calendar.component(.month, from: dpFecha.date)
        let dia = calendar.component(.day, from: dpFecha.date)
        let hora = calendar.component(.hour, from: dpHora.date)
        let minuto = calendar.component(.minute, from: dpHora.date)
        
        var fechaYHora:Date
        
        //fechaYHora = formatter.date(from: "\(año)/\(mes)/\(dia) \(hora):\(minuto)")!
        fechaYHora = formatter.date(from: "\(mes)-\(dia)-\(año) \(hora):\(minuto)")!
        return fechaYHora
        
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
            
            lastID = "\(responseString!)" // Sets some variable or text field. Not that its unwrapped because its an optional.
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
