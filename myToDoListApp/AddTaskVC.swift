//
//  AddTaskVC.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/14/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddTaskVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var timeLbl: UITextField!
    @IBOutlet weak var descLbl: UITextField!
    @IBOutlet weak var titleLbl: UITextField!
    
    var ref: FIRDatabaseReference?
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatePicker()
    }
    
// IBActions ############################################################
   
    
    @IBAction func AddTaskPressed(_ sender: Any) {
        addNewTask()
        self.dismiss(animated: true, completion: nil)
//        let homeVC = HomeListVC()
//        homeVC.isCompletedTasksListOn = false
    }

    
    
// FUNCTIONS ############################################################
    
    func initializeDatePicker() {
        datePicker.datePickerMode = UIDatePickerMode.date
        timeLbl.inputView = datePicker
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func addNewTask() {
        if titleLbl.text != "" {
            ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            

            //add new task to tasks node
            let taskDict = ["ID": uid!, "Title": titleLbl.text!, "Description": descLbl.text!, "Time": timeLbl.text!, "Expanded": false] as [String : Any]
            
            ref?.child("tasks").childByAutoId().updateChildValues(taskDict, withCompletionBlock: { (error, reference) in
                if error != nil {
                    print(error.debugDescription)
                    return
                } else {
                    print("New Task added to firebase")
                    
                    let messageID = reference.key
                    
                    self.ref?.child("user-tasks").child(uid!).child(messageID).updateChildValues(["Completion": false])
                    print("New Task added to fan out node")
                }
            })
        }
    }
    
 
// DATE PICKER FUNCTIONS ####################################################
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        timeLbl.text = dateFormatter.string(from: sender.date)
    }
 
//UITextField Delegate - what to do when text field is editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        datePicker.isHidden = false
    }
    
}
