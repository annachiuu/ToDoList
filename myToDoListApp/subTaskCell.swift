//
//  subTaskCell.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/29/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation
import UIKit

protocol subTaskCellDelegate {
    func didDeleteSubTask(at indexPath: IndexPath)
}


class subTaskCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    var delegate: subTaskCellDelegate? = nil
    var title: String!
    var completed: Bool!
    var indexPath: IndexPath!
    
    @IBOutlet weak var checkmark: UIButton!
    
    @IBAction func completeToggled(_ sender: Any) {
        
        completed = !completed
        if completed {
            let struckText = NSMutableAttributedString(string: title!)
            struckText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0,struckText.length))
            titleLbl.attributedText = struckText
            checkmark.setTitle("✔", for: .normal)
            checkmark.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 8)
        } else {
            titleLbl.text = title
            checkmark.setTitle("-", for: .normal)
            checkmark.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
            
        }
        
    }
    
    
    @IBAction func deleteSubTaskPressed(_ sender: Any) {
        
        self.delegate?.didDeleteSubTask(at: indexPath)

    }
    
}
