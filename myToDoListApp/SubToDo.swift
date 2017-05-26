//
//  SubToDo.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/24/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation

class HeaderToDo: toDo {
    
    private var _subTasks: [String]
    
    var subTasks: [String] {
        return _subTasks
    }

    init(Title: String, Description: String, Time: String, subTasks: [String]) {
        self._subTasks = subTasks
        super.init(Title: Title, Description: Description, Time: Time)
    }
    
}

/*
//toDo gets a new variable with an array of subToDo Ids

 
 */
