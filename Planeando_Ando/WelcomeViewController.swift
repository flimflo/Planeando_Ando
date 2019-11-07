//
//  WelcomeViewController.swift
//  Flash Chat
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
        
        imgLogo.layer.cornerRadius = 0.1 * imgLogo.bounds.size.width

        btIniciar_Sesion.layer.cornerRadius = 0.1 * btIniciar_Sesion.bounds.size.width
        
        btRegistrarse.layer.cornerRadius = 0.1 * btRegistrarse.bounds.size.width
 
        
        viewBotones.layer.shadowColor = UIColor.black.cgColor
        viewBotones.layer.shadowOpacity = 1
        viewBotones.layer.shadowOffset = .zero
        viewBotones.layer.shadowRadius = 10
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
