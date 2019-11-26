//
//  JoinEventViewController.swift
//  Planeando_Ando
//
//  Created by Mildred Irais Gil Melchor on 11/22/19.
//

import UIKit

class JoinEventViewController: UIViewController {

    @IBOutlet weak var tfKey: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func ValidateKey(key : String) -> Bool {
        //add the validation keynumber
        return true
    }
    
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return ValidateKey(key: tfKey.text!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send de id event 
    }
}
