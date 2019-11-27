//
//  Informacion_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 11/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class Informacion_ViewController: UIViewController {
    
    var user = Auth.auth().currentUser?.email
    
    var Evento = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = vwVista.frame.size
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if Evento.members[0] != user {
            btOutlet.isHidden = true
        }
        
        
        lbNombre.text = Evento.title
        lbLugar.text = Evento.place
        tvDescripcion.text = Evento.description
        lbFecha.text = "\(Evento.startTime)"
        
        if Evento.members.count == 1{
            lbMiembros.text = "\(Evento.members.count) Miembro"
        }else{
            lbMiembros.text = "\(Evento.members.count) Miembros"
        }
        
        lbCodigoInvitacion.text = Evento.joinId
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vwVista: UIView!
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbLugar: UILabel!
    @IBOutlet weak var tvDescripcion: UITextView!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbMiembros: UILabel!
    @IBOutlet weak var lbCodigoInvitacion: UILabel!
    @IBOutlet weak var btOutlet: UIButton!
    
    
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
        if(segue.identifier == "goToEdit"){
            
            let editVc = segue.destination as! EditarEventoViewController
            
            editVc.Evento = Evento
        }
    }
}
