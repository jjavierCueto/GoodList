//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Javier Cueto on 14/01/22.
//

import UIKit
import RxSwift
import RxRelay

class TaskListViewController: UIViewController {
    
     
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value:[])
    
    private var filteredTask = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func priorityValuedChanged(segmentedControl: UISegmentedControl){
        updateFilteredTask()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addTaskController = segue.destination as? AddTaskViewController else { return }
        
        addTaskController.taskObjectObservable.subscribe { task in
            self.addNewTask(task: task)
        }.disposed(by: disposeBag)

        
    }
    
    private func filterTask(by priority: Priority?) {
        if priority == nil {
            self.filteredTask = tasks.value
        }else{
            self.tasks.map{ tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe { [weak self] tasks in
                self?.filteredTask = tasks
            }.disposed(by: disposeBag)

        }
    }
    
    
    private func updateFilteredTask(){
        let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
        self.filterTask(by: priority)
        reloadTable()
    }
    
    private func addNewTask(task: Task){
        var existingTasks = self.tasks.value
        existingTasks.append(task)
        self.tasks.accept(existingTasks)
        updateFilteredTask()
    }
    
    private func reloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension TaskListViewController: UITableViewDelegate{
    
}


extension TaskListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTask.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = filteredTask[indexPath.row].title
        return cell
    }
    
    
}
