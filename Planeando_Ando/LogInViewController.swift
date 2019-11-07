//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBotones: UIView!
    @IBOutlet weak var btIniciar_Sesion: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLogo.layer.cornerRadius = 0.1 * imgLogo.bounds.size.width

        btIniciar_Sesion.layer.cornerRadius = 0.1 * btIniciar_Sesion.bounds.size.width
               
        viewBotones.layer.shadowColor = UIColor.black.cgColor
        viewBotones.layer.shadowOpacity = 1
        viewBotones.layer.shadowOffset = .zero
        viewBotones.layer.shadowRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            
            if error != nil {
                SVProgressHUD.dismiss()
                let errCode = AuthErrorCode(rawValue: error!._code)

                    switch errCode {
                        case .invalidEmail:
                            self.generateAlert(Message: "Correo invalido")
                            break
                        case .userNotFound:
                            self.generateAlert(Message: "Usuario no encontrado")
                            break
                        case .wrongPassword:
                            self.generateAlert(Message: "Contraseña incorrecta")
                            break
                        default:
                            print("Create User Error: \(String(describing: error))")
                            break
                    }
                
                print(error!)
            }else{
                //Success
                print("Login Successful")
                SVProgressHUD.dismiss()
                           
                self.performSegue(withIdentifier: "goToApp", sender: self)
            }
        }
    }
    
    func generateAlert(Message: String) {
        
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continuar", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }


    
}  
