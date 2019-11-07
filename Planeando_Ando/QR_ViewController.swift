//
//  QR_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 10/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class QR_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //obtenerInfo()
        //cargarQR()
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
    }
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var imQR: UIImageView!
    @IBOutlet weak var lbPuntos: UILabel!
    

    func obtenerInfo(){
        
        var user = Auth.auth().currentUser?.email
        user?.removeLast(9)
        
        let ref = Database.database().reference().child(user!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String:Any]
            
            self.lbNombre.text = snapshotValue["Nombre"]! as! String
            self.lbPuntos.text = String(snapshotValue["Puntos"]! as! Int)
        }
    }
    
    func cargarQR(){
        var user = Auth.auth().currentUser?.email
        user?.removeLast(9)
        
        let path = "QR/" + user! + ".png"
        let storageRef = Storage.storage().reference(withPath: path)
        
        storageRef.getData(maxSize: 4 * 1024 * 1024) { [weak self] (data, error) in
            
            if let error = error {
                print("Error al cargar QR")
                return
            }
            if let data  = data {
                self?.imQR.image = UIImage(data: data)
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

}
