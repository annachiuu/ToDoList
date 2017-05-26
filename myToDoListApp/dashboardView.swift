//
//  dashboardView.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/18/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import UIKit


class DashBoardView: UIVisualEffectView {
    
    var originalCenter = CGPoint()
    var isSwipeSucessful = false
    
    override func awakeFromNib() {
        layer.frame.size.width = superview!.frame.size.width / 3
        initializePGR()
        initializeTGesture()
    }
    
// ########################################  ScreenEdgePanGesture Setup
    
    func initializePGR() {
        let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe))
        recognizer.edges = .right
        superview?.addGestureRecognizer(recognizer)
    }
    
    func checkIfSwiped(recognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = recognizer.translation(in: superview!)
        center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        isSwipeSucessful = frame.origin.x > frame.size.width / 2.0
    }
    
    func snapToPosition() {
        UIView.animate(withDuration: 0.2) {
            let showingframe = CGRect(x: self.superview!.frame.size.width-150, y: 0, width: 150, height: 200)
            self.frame = showingframe
        }
    }

    func handleSwipe(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .began {
            originalCenter = center
        }
        
        if recognizer.state == .changed {
            checkIfSwiped(recognizer: recognizer)
        }
        
        if recognizer.state == .ended {
            snapToPosition()
            if isSwipeSucessful {
                print("Swipeddddd")
            }
        }
    }
    
 // #############################################   TapGesture Setup

    func initializeTGesture() {
        let tGesture = UITapGestureRecognizer(target: self, action: #selector(handle2Tap))
        tGesture.numberOfTapsRequired = 2
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tGesture)
        
    }
    
    func handle2Tap() {
        print("double tapped")
        UIView.animate(withDuration: 0.4) {
            self.center = self.originalCenter
        }
    }
    
}
