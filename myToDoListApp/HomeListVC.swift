//
//  HomeListVC.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/10/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class HomeListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TableViewCellDelegate {
    
//  Declarations  #######################################################
    @IBOutlet weak var welcomeView: MaterialView!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var toCompLbl: UILabel!
    @IBOutlet weak var sideMenu: DashBoardView!
    
    @IBOutlet weak var UserNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBOutlet weak var titleEditLbl: MaterialTxtField!
    @IBOutlet weak var descEditLbl: MaterialTxtField!
    @IBOutlet weak var timeEditLbl: MaterialTxtField!
    
    @IBOutlet weak var PopUpHeight: NSLayoutConstraint!


    var tasks = [toDo]()
    var completedTasks = [toDo]()
    var isCompletedTasksListOn = false
    var taskEditingId: String?
    
    var ref: FIRDatabaseReference?
    
    var datePicker = UIDatePicker()
    
//  ViewDidLoad  #######################################################

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserIsLoggedIn()
        
        tableView.delegate = self
        tableView.dataSource = self

        UserNameLbl.layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 1.0).cgColor
        UserNameLbl.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        UserNameLbl.layer.shadowOpacity = 1.0
        UserNameLbl.layer.shadowRadius = 1.0
        
        initializePopUpView()
        observeUserToDoList()
        initializeTaskTapGesture()
    }


//  IBAction Functions  ########################################################

    
    @IBAction func LogOutBtnPressed(_ sender: Any) {
        handleLogout()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddVC", sender: self)
    }


    @IBAction func exitPopUp(_ sender: Any) {
        UIView.animate(withDuration: 0.5) { 
            self.popUpView.isHidden = true
            self.exitButton.isHidden = true
        }
        
    }
    @IBAction func popUpSubmitPressed(_ sender: Any) {
        if titleEditLbl.text != "" {
            ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid

            let taskDict = ["ID": uid!, "Title": titleEditLbl.text!, "Description": descEditLbl.text!, "Time": timeEditLbl.text!] as [String : Any]
            
            ref?.child("tasks").child(taskEditingId!).updateChildValues(taskDict, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err.debugDescription)
                    return
                } else {
                    print("Task with ID: \(ref.key) update")
                    self.exitPopUp(self)
                }
            })
            

        }
        self.observeUserToDoList()
        self.datePicker.removeFromSuperview()
    }
    
//  FUNCTIONS  ########################################################
    
//    #################### PopUpView
    
    func initializePopUpView() {
        popUpView.center = self.view.center
        popUpView.isHidden = true
        exitButton.isHidden = true
        
        //tap gesture to activate datepicker
        let tapToDateGesture = UITapGestureRecognizer(target: self, action: #selector(datePickerActivated))
        tapToDateGesture.numberOfTapsRequired = 1
        timeEditLbl.isUserInteractionEnabled = true
        timeEditLbl.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        self.timeEditLbl.addGestureRecognizer(tapToDateGesture)
        
    }
    
    func datePickerActivated() {
        print("datePickerActivated")
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        timeEditLbl.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timeEditLbl.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
//    ########### TAP GESTURE FOR LIST TOGGLE
    
    func initializeTaskTapGesture() {
        
        let tapGestureComplete = UITapGestureRecognizer(target: self, action: #selector(handle1TapCompleted))
        let tapGestureIncomplete = UITapGestureRecognizer(target: self, action: #selector(handle1TapIncomplete))
        tapGestureComplete.numberOfTapsRequired = 1
        tapGestureIncomplete.numberOfTapsRequired = 1
        
        completedLbl.isUserInteractionEnabled = true
        completedLbl.addGestureRecognizer(tapGestureComplete)
        PopUpHeight.constant = UIScreen.main.bounds.width * 0.80
        toCompLbl.isUserInteractionEnabled = true
        toCompLbl.addGestureRecognizer(tapGestureIncomplete)
    }
    
    func handle1TapCompleted() {
        print("tapGestureComplete registered")
        isCompletedTasksListOn = true
        self.tableView.reloadData()
    }
    
    func handle1TapIncomplete() {
        print("tapGestureIncomplete registered")
        isCompletedTasksListOn = false
        self.tableView.reloadData()
    }
    
    
    func updateCompletionLabels() {
        self.toCompLbl.text = "\(tasks.count)"
        self.completedLbl.text = "\(completedTasks.count)"
        self.tableView.reloadData()
    }

    
//    ###########################################
    
    
    
    func observeUserToDoList() {
        
        tasks = [toDo]()

        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        ref = FIRDatabase.database().reference().child("user-tasks").child(uid)
        let q_incomplete = ref?.queryOrdered(byChild: "Completion").queryEqual(toValue: false)
        let q_completed = ref?.queryOrdered(byChild: "Completion").queryEqual(toValue: true)

        
        q_incomplete?.observe(.childAdded, with: { (snapshot) in
            
            let messageID = snapshot.key
            let messageRef = FIRDatabase.database().reference().child("tasks").child(messageID)

            messageRef.observeSingleEvent(of: .value, with: { (UserSnapshot) in
                if let taskDict = UserSnapshot.value as? [String: AnyObject] {
                    let task = toDo(taskKey: UserSnapshot.key, dictionary: taskDict)
                    self.tasks.append(task)
                    self.tasks.sort(by: {$0.time < $1.time})
                    self.updateCompletionLabels()
                }
            })
        })
            
        q_completed?.observe(.childAdded, with: { (snapshot) in
            
            let messageID_c = snapshot.key
            let messageRef_c = FIRDatabase.database().reference().child("tasks").child(messageID_c)

            messageRef_c.observeSingleEvent(of: .value, with: { (snapshot) in
            if let taskDict = snapshot.value as? [String: AnyObject] {
                    let task = toDo(taskKey: snapshot.key, dictionary: taskDict)
                    self.completedTasks.append(task)
                    self.updateCompletionLabels()
                }
            })
        })
        
    
    
    }
    
 
    


    func checkIfUserIsLoggedIn() {
        
        if FIRAuth.auth()?.currentUser == nil {
            performSelector(inBackground: #selector(handleLogout), with: nil)
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FDREF.child("user").child(uid!).observe(.value, with: { (snapshot) in
                
                print("User is logged in")
                
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    self.UserNameLbl.text = dictionary["ID"] as? String
                    
                }
                
                
            }, withCancel: nil)
            
        }
        
    }
    
    func handleLogout() {
        
        try! FIRAuth.auth()?.signOut()
        print("Logged out")
        
        dismiss(animated: true, completion: nil)

    }
    
    func deleteTaskFromFirebase(indexPath: IndexPath) {
        
        ref = FIRDatabase.database().reference()
        
        let task = array()[indexPath.row].taskKey
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        self.ref?.child("user-tasks").child("\(uid)/\(task)").removeValue(completionBlock: { (err, refDelete) in
            if err != nil {
                print(err.debugDescription)
                return
            } else {
                print("Deleted from user-tasks ref: \(refDelete.key)")
                self.ref?.child("tasks/\(refDelete.key)").removeValue(completionBlock: { (err2, refDelete2) in
                    if err2 != nil {
                        print(err2.debugDescription)
                        return
                    } else {
                        print("Deleted task: \(refDelete2.description())")
                    }
                })
            }
        })
        
    }
    


    
//  UITableView Delegate  ########################################################
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isCompletedTasksListOn ? completedTasks.count: tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoCell {
            
            cell.delegate = self
            
            let currentTask  = isCompletedTasksListOn ? completedTasks[indexPath.row] : tasks[indexPath.row]

            cell.configureCell(Title: currentTask.title , Description: currentTask.description, Time: currentTask.time)
            return cell
            
        } else {
            return ToDoCell()
            
        }
    }
    
    func array() -> [toDo] {
        let array = isCompletedTasksListOn ? completedTasks : tasks
        return array
    }
    
    
//    ######################################################### CUSTOM DELEGATES
    
    func didDeleteCell(cell: UITableViewCell) {
        
            if let indexPath = self.tableView.indexPath(for: cell) {
                print("Will be deleted")
                deleteTaskFromFirebase(indexPath: indexPath)
                
                if isCompletedTasksListOn {
                    completedTasks.remove(at: indexPath.row)
                } else {
                    tasks.remove(at: indexPath.row)

                }
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.updateCompletionLabels()
            }
    }
    
    func didCheckCell(cell: UITableViewCell) {
        
            if let indexPath = self.tableView.indexPath(for: cell) {
                
                let taskId = array()[indexPath.row].taskKey
                let checkBool = isCompletedTasksListOn ? false : true

                ref = FIRDatabase.database().reference().child("tasks").child(taskId)
                
                ref?.updateChildValues(["Completion": checkBool])
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                let refFan = FIRDatabase.database().reference().child("user-tasks").child(uid)
                refFan.child(taskId).updateChildValues(["Completion": checkBool])
            
                
                //transfer task to completedTask / tasks array
                if isCompletedTasksListOn {
                    completedTasks.remove(at: indexPath.row)
                } else {
                    tasks.remove(at: indexPath.row)
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.updateCompletionLabels()

                print("task \(taskId): completed")
                
        }
    }
    
    func didLongPress(cell: UITableViewCell) {
        print("long press register")
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { 
            self.popUpView.isHidden = false
            self.exitButton.isHidden = false
        }, completion: nil)
        
        //load cell values into popupview
        if let indexPath = self.tableView.indexPath(for: cell) {
            let editingTask = tasks[indexPath.row]
            titleEditLbl.text = editingTask.title
            descEditLbl.text = editingTask.description
            timeEditLbl.text = editingTask.time
            taskEditingId = editingTask.taskKey
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.datePicker.isHidden = true
    }

}

