//
//  File.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/10/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

let DARKGRAY = CGFloat(137.0/255.0)
let FDREF = FIRDatabase.database().reference()

class MaterialBtn: UIButton {
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 0.8).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        
    }
}

class MaterialSegmentCtrl: UISegmentedControl {
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.4
        
    }
}

class MaterialTxtField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        
    }
}


class MaterialView: UIView {
    
    override func awakeFromNib() {
        layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 0.5).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
        
    }
}

class SubTaskMaterialView: UIView {
    override func awakeFromNib() {
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor(red: DARKGRAY, green: DARKGRAY, blue: DARKGRAY, alpha: 0.5).cgColor
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8
    
    }
}

class PopUpView: MaterialView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.cornerRadius = 5.0
        let ScreenSize = UIScreen.main.bounds
        self.frame = CGRect(x: 0, y: 0, width: ScreenSize.width - 70, height: ScreenSize.height * 0.80)
        
        
    }
}

