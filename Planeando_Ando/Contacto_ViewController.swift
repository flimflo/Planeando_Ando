//
//  Contacto_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 10/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class Contacto_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
    }
    

    @IBAction func Cerrar_sesion(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error al salir de la aplicación")
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
