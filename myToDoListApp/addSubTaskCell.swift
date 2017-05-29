//
//  addSubTaskCell.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit

protocol AddSubTaskCellDelegate: class {
    func newSubTaskAdded(text: String, in section: Int)
}

class addSubTaskCell: UITableViewCell {
    
    var delegate: AddSubTaskCellDelegate? = nil
    var section: Int!
    
    @IBOutlet weak var newTitleTxtField: MaterialTxtField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func addSubTaskPressed(_ sender: Any) {
        
        if newTitleTxtField.text != "" {
            self.delegate?.newSubTaskAdded(text: newTitleTxtField.text!, in: section)
        }
        newTitleTxtField.text = ""
    }
    
    
}
