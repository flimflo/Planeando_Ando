//
//  NewEventViewController.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores on 10/11/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController {
    
    @IBOutlet weak var vwVista: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.contentSize = vwVista.frame.size
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
    }
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBAction func infoTextField(_ sender: UITextField) {
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
