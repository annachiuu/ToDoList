//
//  ToDo.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/11/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation
import FirebaseDatabase


class toDo {
    
    private var _title: String
    private var _description: String
    private var _time: String
    private var _taskKey: String
    private var _subTasks: [toDo]
//    private var _subTasks: [String]

    
    var expanded: Bool!
    
    var title: String {
        return _title
    }
    
    var description: String  {
        
        return _description
    }
    
    var time: String {
        return _time
    }
    
    var taskKey: String {
        return _taskKey
    }
    
    var subTasks: [toDo] {
        get {
            return _subTasks
        }
        set {
            self._subTasks = newValue
        }
    }
    
    
    init(Title: String, Description: String, Time: String, Expanded: Bool) {
        _title = Title
        _description = Description
        _time = Time
        _taskKey = ""
        _subTasks = [toDo]()
        expanded = Expanded
    }
    
    init(Title: String) {
        _title = Title
        _description = ""
        _time = ""
        _taskKey = ""
        _subTasks = [toDo]()
        expanded = false
    }
    
    
    init(taskKey: String, dictionary: [String: AnyObject]) {
        self._taskKey = taskKey
        if let title = dictionary["Title"] as? String {
            self._title = title
        } else {
            self._title = ""
        }
        if let desc = dictionary["Description"] as? String {
            self._description = desc
        } else {
            self._description = ""
        }
        if let time = dictionary["Time"] as? String {
            self._time = time
        } else {
            self._time = ""
        }
        
        if let expanded = dictionary["Expanded"] as? Bool {
            self.expanded = expanded
        }
        
        self._subTasks = [toDo]()

//        if let tasksDict = dictionary["Subtasks"] as? [String: String] {
//            print(tasksDict)
//            let subTasks = tasksDict["Title"]
//            self._subTasks.append(toDo(Title:subTasks!))
//        }
        
    }



}
