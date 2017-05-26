//
//  toDoCell.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/11/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func didDeleteCell(cell: UITableViewCell)
    func didCheckCell(cell:UITableViewCell)
    func didLongPress(cell:UITableViewCell)
}


let CELL_H: CGFloat = 88

class ToDoCell: UITableViewCell {
    
    var originalCenter = CGPoint()
    var delegate: TableViewCellDelegate? = nil
    var isSwipeRightSucessful = false
    var isSwipeLeftSucessful = false
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Paninitialize()
        initializeLongGesture()
    }
    
    func configureCell(Title: String, Description: String, Time: String) {
        
        TitleLbl.text = Title
        DescLbl.text = Description
        timeLbl.text = Time
    }
    
//    #################################### PAN GESTURE 
    
    func Paninitialize() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    func checkIfSwiped(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self) //translation is the distance travelled by finger
        center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        isSwipeRightSucessful = frame.origin.x > frame.size.width / 2.0
        isSwipeLeftSucessful = (frame.origin.x + (frame.size.width)) < frame.size.width / 2.0
    }
    
    func moveViewBackIntoOrigin(originalFrame: CGRect) {
        UIView.animate(withDuration: 0.3) { 
            self.frame = originalFrame
        }
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            originalCenter = center
        }
        
        if recognizer.state == .changed {
            checkIfSwiped(recognizer: recognizer)
            
        }
        
        if recognizer.state == .ended {
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if isSwipeRightSucessful {
               self.delegate?.didDeleteCell(cell: self)
            } else if isSwipeLeftSucessful{
                self.delegate?.didCheckCell(cell:self)
            }else {
                moveViewBackIntoOrigin(originalFrame: originalFrame)
            }
            
        }
        
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
        }
        return false
    }
    
    
//    ############################################# LONG HELD GESTURE 
    
    func initializeLongGesture() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longGesture)
    }
    
    
    func handleLongPress(){
        
        self.delegate?.didLongPress(cell: self)
        print("longPressed detected")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
