//
//  ViewController.swift
//  Messenger
//
//  Created by Phan Thi Quynh on 06/05/2023.
//

import UIKit
import ProgressHUD
import Firebase
import FirebaseFirestore
class LoginViewController: UIViewController {
    
    //vars
    
    var isLogin = true
    //label Outlet
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var signUpLabel: UILabel!
    //Outlet Text Field
    
    //Label TextFIeld
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Button Outlet
    
    @IBOutlet weak var loginOutlet: UIButton!
    
    @IBOutlet weak var registerOutlet: UIButton!
    
    @IBOutlet weak var resendOutlet: UIButton!
    
    //Button Action
    
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        if dataInputFor(type: "password"){
            //reset password
            print("test forgot pass")
        }else{
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    
    
    @IBAction func resendEmailPressed(_ sender: Any) {
        if dataInputFor(type: "password"){
            //resend email
            print("test  resend email")
        }else{
            ProgressHUD.showFailed("Email is required.")
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if dataInputFor(type: isLogin ? "login" : "register"){
            print("test Login")
            //if login true, login, else register
            isLogin ? loginUser() : registerUser()
        }else{
            ProgressHUD.showFailed("All Fields are required")
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUIFor(login: true)
    }
    
    
    
    func updateUIFor(login: Bool){
        loginOutlet.setImage(UIImage(named: login ? "loginBtn" : "registerBtn"), for: .normal)
        registerOutlet.setTitle(login ? "Sign up" : "Login", for: .normal)
        signUpLabel.text = login ? "Don't have an account?" : "Have an account?"
        
        UIView.animate(withDuration: 0.5 ){
            self.repeatPasswordTextField.isHidden = login
            self.repeatPasswordLabel.isHidden = login
            self.resendOutlet.isHidden = login
        }
    }
    
    
    //-Helpers
    
    func dataInputFor(type: String) -> Bool{
        switch type{
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "register":
            return emailTextField.text != "" && passwordTextField.text != "" &&
            repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
            
        }
    }
    private func loginUser(){
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error,isEmailVerified) in
            
            if error == nil{
                if isEmailVerified{
                    print("User has logged in", User.currentUser?.email)
                }else{
                    ProgressHUD.showFailed("Please verify your email.")
                    self.resendOutlet.isHidden = false
                }
            }else{
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
        
    }
    private func registerUser (){
        if passwordTextField.text! == repeatPasswordTextField.text!{
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil{
                    ProgressHUD.showSucceed("Verification email sent")
                    self.resendOutlet.isHidden = false
                }else{
                    print(error?.localizedDescription)
                }
            }
        }else{
            ProgressHUD.showError("Please ensure password is matched")
        }
    }
    
//    Download user from firebase
//    Email is nil cuz not always have it
    
    
    
    
    
    
//
//    func validateInput(userEmail: String, password: String, retypePassword: String, username: String){
//
//
//
//        let expression = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
//
//
//        guard !userEmail.isEmpty else{
//            displayMessage(title: "Error", message: "Please enter your Email")
//            return
//        }
//
//        let predicate = NSPredicate(format: "SELF MATCHES %@", expression)
//        if !predicate.evaluate(with: userEmail) {
//            displayMessage(title: "Error", message: "Please enter a correct email")
//        }
//
//        guard !password.isEmpty else{
//            displayMessage(title: "Error", message: "Please enter your password")
//            return
//        }
//        guard !retypePassword.isEmpty else{
//            displayMessage(title: "Error", message: "Please re-enter your password")
//            return
//        }
//        guard !username.isEmpty else{
//            displayMessage(title: "Error", message: "Please enter your User name")
//            return
//        }
//
//        if password.count < 8 {
//            displayMessage(title: "Error", message: "Please ensure that password is greater than 8 character")
//            return
//        }
//        if password != retypePassword {
//            displayMessage(title: "Error", message: "The retype password does not match with the password field ")
//            return
//        }
//
//    }
//    func displayMessage(title: String, message: String) {
//            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
//    }

}

