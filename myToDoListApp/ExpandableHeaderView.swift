//
//  ExpandableHeaderView.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/27/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate: class {
    func didTapTask(in section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {

    weak var delegate: ExpandableHeaderViewDelegate? = nil
    var section: Int!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    
    override func awakeFromNib() {
        
        self.isUserInteractionEnabled = true
        initializeTG()
    }
    
    func initializeTG() {
        let TG = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        TG.numberOfTapsRequired = 1
        self.addGestureRecognizer(TG)
    }
    
    
    func handleTap() {
        print("handleTap")
        self.delegate?.didTapTask(in: section)
    }
    
    func configureHeader(title: String, description: String, time: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        timeLbl.text = time
        TitleLbl.text = title
        DescLbl.text = description
        self.section = section
        self.delegate = delegate
    }

}
