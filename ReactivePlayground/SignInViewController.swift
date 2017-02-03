//
//  SignInViewController.swift
//  ReactivePlayground
//
//  Created by Matthew on 23/11/2016.
//  Copyright © 2016 Matthew. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInFailureTextLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    private var isValidUsername: Bool {
        return usernameTextField.text!.characters.count > 3
    }
    
    private var isValidPassword: Bool {
        return passwordTextField.text!.characters.count > 3
    }
    
    private let signInService: DummySignInService = DummySignInService()
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUIState()
        
        // Handle text changes for both text fields.
        usernameTextField.addTarget(
            self, action: #selector(SignInViewController.usernameTextFieldChanged), for: .editingChanged
        )
        passwordTextField.addTarget(
            self, action: #selector(SignInViewController.passwordTextFieldChanged), for: .editingChanged
        )
        
        // Initially hide the failure message.
        signInFailureTextLabel.isHidden = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    // MARK: - IBActinos
    @IBAction func signIn(_ sender: UIButton) {
        // disable all UI controls
        signInButton.isEnabled = false
        signInFailureTextLabel.isHidden = true
        
        signInService.signIn(withUsername: usernameTextField.text!, andPassword: passwordTextField.text!) {
            success in
            
            self.signInButton.isEnabled = true
            self.signInFailureTextLabel.isHidden = success
            
            if success {
                self.performSegue(withIdentifier: "signInSuccess", sender: self)
            }
        }
    }
    
    // MARK: - Callback Methods
    @objc private func usernameTextFieldChanged() {
        updateUIState()
    }
    
    @objc private func passwordTextFieldChanged() {
        updateUIState()
    }

    // MARK: - Private Methods
    private func updateUIState() {
        // Updates the enabled state and style of the text fields based on whether the current username and password combo is valid.
        usernameTextField.backgroundColor = isValidUsername ? UIColor.clear : UIColor.yellow
        passwordTextField.backgroundColor = isValidPassword ? UIColor.clear : UIColor.yellow
        
        signInButton.isEnabled = isValidUsername && isValidPassword
    }
}

