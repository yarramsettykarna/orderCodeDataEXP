//
//  RegisterViewController.swift
//  OrderManagement
//
//  Created by karna yarramsetty on 09/05/21.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    var userCreatedOk: Bool!
    var users = [User]()
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        //making validations
        guard let email = userEmailTextField.text,  email != "" else {
            displayMessage(message: "Empty user name")
            userCreatedOk = false
            return
        }
        guard let password = userPasswordTextField.text,  password != "",
              let repeatPassword = userRepeatPasswordTextField.text, repeatPassword == password else {
            displayMessage(message: "Empty password or passwords don't match")
            userCreatedOk = false
            return
        }
        userCreatedOk = true
        //Saving data
        let user = User(context: PersistenceService.context)
        user.email = email
        user.password = password
        PersistenceService.saveContext()
        self.users.append(user)
        
        displayMessage(message: "Registration is successful !")
        print(user.email)
        print(user.password)
        
    }
    
    
    func displayMessage(message:String){
        let myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
        myAlert.addAction(action)
        present(myAlert,animated: true, completion: {
            if self.userCreatedOk {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
