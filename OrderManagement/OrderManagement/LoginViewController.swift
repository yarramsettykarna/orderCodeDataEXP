//
//  LoginViewController.swift
//  OrderManagement
//
//  Created by karna yarramsetty on 09/05/21.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    var users = [User]()
    var unchecked = true
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var userPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do{
            let users = try PersistenceService.context.fetch(fetchRequest)
            self.users = users
        }catch{}
    }
    @IBAction func check(_ sender: UIButton) {
        if unchecked {
            sender.setImage(UIImage(named:"checked.png"), for: .normal)
            unchecked = false
        }
        else {
            sender.setImage( UIImage(named:"unchecked.png"), for: .normal)
            unchecked = true
        }
        UserDefaults.standard.set(userEmailTextField.text, forKey: "userName")
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        var getUserCredentials = false
        for user in users{
            if user.email == userEmailTextField.text && user.password == userPasswordTextField.text {
                //displayMessage(message: "Welcome \(user.email)")
                getUserCredentials = true
                navigateToListVC()
                break
            }
        }
        
        if !getUserCredentials {
            displayMessage(message: "Invalid User name or password, please try again ")
        }
        
    }
    
    
    func displayMessage(message:String) {
        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(action)
        self.present(myAlert,animated: true,completion: nil)
        
    }
    func navigateToListVC() {
        if !unchecked {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
        } else {
            displayMessage(message: "pls tick")
        }
    }

}


extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
