//
//  Informacion_ViewController.swift
//  INC_MTY
//
//  Created by Fernando Limón Flores on 11/10/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class Informacion_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView.contentSize = vwVista.frame.size
        self.tabBarController?.navigationController?.navigationItem.hidesBackButton = true
    }

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vwVista: UIView!

}
