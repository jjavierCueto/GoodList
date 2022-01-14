//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by Javier Cueto on 14/01/22.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    private let taskSubject = PublishSubject<Task>()
    var taskObjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: prioritySegment.selectedSegmentIndex),
              let title = self.textField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        dismiss(animated: true, completion: nil)
    }
    
    
}
