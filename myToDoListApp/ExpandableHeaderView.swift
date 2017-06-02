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
    func didDeleteCell(in section: Int)
    func didCheckCell(in section: Int)
    func didLongPress(in section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {

    weak var delegate: ExpandableHeaderViewDelegate? = nil
    var section: Int!
    var isSwipeRightSucessful = false
    var isSwipeLeftSucessful = false
    var originalCenter = CGPoint()

    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var DescLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        
        self.isUserInteractionEnabled = true
        initializeTG()
        Paninitialize()
        self.contentView.backgroundColor = UIColor.white
    }
//    ##################### PAN GESTURE

    
    func Paninitialize() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        recognizer.delegate = self as! UIGestureRecognizerDelegate
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
            if isSwipeLeftSucessful {
                self.delegate?.didDeleteCell(in: section)
            } else if isSwipeRightSucessful{
                self.delegate?.didCheckCell(in: section)
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
//    #####################
    
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
