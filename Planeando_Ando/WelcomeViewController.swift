//
//  WelcomeViewController.swift
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit



class WelcomeViewController: UIViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBotones: UIView!
    @IBOutlet weak var btIniciar_Sesion: UIButton!
    @IBOutlet weak var btRegistrarse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btIniciar_Sesion.layer.cornerRadius = 5
        btRegistrarse.layer.cornerRadius = 5
 
        viewBotones.layer.shadowColor = UIColor.black.cgColor
        viewBotones.layer.shadowOpacity = 0.35
        viewBotones.layer.shadowOffset = .zero
        viewBotones.layer.shadowRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
