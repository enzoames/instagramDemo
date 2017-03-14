//
//  ViewController.swift
//  InstagramDemo
//
//  Created by Enzo Ames on 3/13/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapLogin(_ sender: Any)
    {
        PFUser.logInWithUsername(inBackground: usernameField.text!,
                                 password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil
            {
                print("You're loged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else
            {
                print("error: \(error?.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func onTapSignup(_ sender: Any)
    {
        let newUser = PFUser()
        
        if let username = usernameField
        {
            newUser.username = username.text!
        }
        
        if let pasword = passwordField
        {
            newUser.password = pasword.text!
        }
        
        print("\(newUser.username)")
        print("\(newUser.password)")
        
        newUser.signUpInBackground
        { (success: Bool, error: Error?) in
            if success
            {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Created User")
            }
            else
            {
                print("Error: \(error?.localizedDescription)")
            }
        }
    
    }
    

}

