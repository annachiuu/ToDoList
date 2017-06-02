//
//  ViewController.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/9/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController {

    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var userIDTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    var ref: FIRDatabaseReference?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIsUserLoggedIn()

        
        if segmentCtrl.selectedSegmentIndex == 1 {
            userIDTxtField.isHidden = false
        } else {
            userIDTxtField.isHidden = true
        }
        
    }
    
    
    
    func checkIsUserLoggedIn() {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
            }
            
            if user != nil {
                //user is signed in
                
                self.performSegue(withIdentifier: "toHomelist", sender: self)
            } else {
                print("no user logged in")
                return
            }
        })
        
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if segmentCtrl.selectedSegmentIndex == 0 {
            
            if let email = emailTxtField.text, let pwd = pwdTxtField.text{
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    
                    if user != nil {
                        
                        self.performSegue(withIdentifier: "toHomelist", sender: self)
                        
                    } else {
                        
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("ERROR 404")
                        }
                    }
                    
                })
                
            }

                
        } else {
            
            if let email = emailTxtField.text, let pwd = pwdTxtField.text, let userID = userIDTxtField.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    
                    if user != nil {
                        
                        self.ref = FIRDatabase.database().reference()
                        
                        guard let uid = user?.uid else {
                            return
                        }
                        
                        let newUser = ["ID": userID, "Email": email, "Password": pwd]
                        
                        self.ref?.child("user").child(uid).setValue(newUser, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print("\(String(describing: err))")
                                return
                            } else {
                                print("sucessfully created new user")
                            }
                        })
                        
                        
                        
                    } else {
                        
                        if let myError = error?.localizedDescription {
                            print(myError)
                        } else {
                            print("ERROR 404")
                        }
                    }
                    
                })
                
            }

        }
    }
        
        
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            userIDTxtField.isHidden = true
            loginBtn.setTitle("Log In", for: .normal)
        case 1:
            userIDTxtField.isHidden = false
            loginBtn.setTitle("Sign in", for: .normal)
        default:
            break
        }
        
    }

    
    


}

