//
//  Horario_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 11/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class Horario_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        obtenerInfo()
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
    }
    
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbHora: UILabel!
    @IBOutlet weak var lbLugar: UILabel!
    
    func obtenerInfo(){
        
        var user = Auth.auth().currentUser?.email
        user?.removeLast(9)
        
        let ref = Database.database().reference().child(user!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String:Any]
            
            self.lbFecha.text = snapshotValue["Fecha"]! as! String
            self.lbHora.text = snapshotValue["Hora"]! as! String
            self.lbLugar.text = snapshotValue["Lugar"]! as! String
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

}
