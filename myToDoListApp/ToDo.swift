//
//  ToDo.swift
//  myToDoListApp
//
//  Created by Anna Chiu on 5/11/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation


class toDo {
    
    private var _title: String
    private var _description: String
    private var _time: String
    private var _taskKey: String
    private var _subTasks: [String]
    
    
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
    
    
    init(Title: String, Description: String, Time: String) {
        _title = Title
        _description = Description
        _time = Time
        _taskKey = ""
        _subTasks = [String]()
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
        self._subTasks = [String]()

    }
    
}
