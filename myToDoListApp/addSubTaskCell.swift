//
//  addSubTaskCell.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol AddSubTaskCellDelegate: class {
    func newSubTaskAdded(text: String, in section: Int)
}

class addSubTaskCell: UITableViewCell {
    
    var delegate: AddSubTaskCellDelegate? = nil
    var section: Int!
    var sectionID: String!
    
    var ref: FIRDatabaseReference?
    
    @IBOutlet weak var newTitleTxtField: MaterialTxtField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func addSubTaskPressed(_ sender: Any) {
        
        if newTitleTxtField.text != "" {
            let task = newTitleTxtField.text
            self.delegate?.newSubTaskAdded(text: task!, in: section)
            
            let ref = FIRDatabase.database().reference()
            
            ref.child("tasks").child(self.sectionID).child("Subtasks").childByAutoId().updateChildValues(["Title": task!], withCompletionBlock: { (error, REF) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Added \(REF) to Firebase")
                }
            })
        
            
        }
        newTitleTxtField.text = ""
        
    }
    
    
}
