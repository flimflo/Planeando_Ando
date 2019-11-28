//
//  RegisterViewController.swift
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    //Pre-linked IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewBotones: UIView!
    @IBOutlet weak var btRegistrarse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        imgLogo.layer.cornerRadius = 0.1 * imgLogo.bounds.size.width

        btRegistrarse.layer.cornerRadius = 0.1 * btRegistrarse.bounds.size.width
               
        viewBotones.layer.shadowColor = UIColor.black.cgColor
        viewBotones.layer.shadowOpacity = 0.35
        viewBotones.layer.shadowOffset = .zero
        viewBotones.layer.shadowRadius = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    @IBAction func registerPressed(_ sender: AnyObject) {
        //TODO: Set up a new user on our Firbase database
        SVProgressHUD.show()
        if((tfNombre.text!) == ""){
            SVProgressHUD.dismiss()
            self.generateAlert(Message: "Falta llenar el campo de nombre")
        }else{
            Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
                
                if error != nil {
                    SVProgressHUD.dismiss()
                    print(error!)
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                            case .invalidEmail:
                                self.generateAlert(Message: "Correo invalido")
                                break
                            case .emailAlreadyInUse:
                                self.generateAlert(Message: "Correo ya registrado")
                                break
                            case .missingEmail:
                                self.generateAlert(Message: "Campo de correo vacio")
                                break
                            case .weakPassword:
                                self.generateAlert(Message: "La contraseña debe tener minimo 6 caracteres")
                                break
                            default:
                                print("Create User Error: \(String(describing: error))")
                                break
                        }
                    }
                }else{
                    //Success
                    print("Registration Successful")
                    
                    /*var user = self.emailTextfield.text!
                    user.removeLast(9)
                    user.removeFirst()
                    user = "a" + user
                    
                    self.uploadQR(user: user)*/
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "goToApp", sender: self)
                    
                }
            }
        }
    }
    
    func uploadInfo(user: String){
        
        let ref = Database.database().reference()
    ref.child(user).setValue(["Nombre":self.tfNombre.text!,"Apellido_pat":"","Apellido_mat":"","Fecha":"","Hora":"","Lugar":"","Puntos":0]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            }
            else {
                print("Data saved successfully!")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToApp", sender: self)
            }
        }
    }
    
    /*func uploadQR(user: String){
        
        let uploadRef = Storage.storage().reference(withPath: "QR/\(user).png")
        
        guard let imageData = generateQRCode(from: user)?.pngData() else {
            return
        }
        
        let uploadMetadata = StorageMetadata.init()
        
        uploadMetadata.contentType = "image/png"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            
            if let error = error {
                print("Error en: \(error.localizedDescription)")
                return
            }
            print("Archivo subido exitosamente")
            self.uploadInfo(user: user)
        }
    }*/
    
    /*func generateQRCode(from string:String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            
            filter.setValue(data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
            
        }
        return nil
    }*/
    
    func generateAlert(Message: String) {
        
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continuar", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
