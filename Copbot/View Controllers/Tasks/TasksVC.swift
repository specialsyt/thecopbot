//
//  TasksVC.swift
//  Copbot
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TasksVC: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    var selectedTasks = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tasksTableView.reloadData()
    }
    
    @IBAction func onPressStart(_ sender: Any) {
        if AppData.tasks.count > 0 {
            selectedTasks = Array(0...AppData.tasks.count - 1)
            self.performSegue(withIdentifier: "ReadyToCopVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReadyToCopVC" {
            let dest = segue.destination as! ReadyToCopVC
            dest.selectedTasks = self.selectedTasks
        }
    }
}

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = AppData.tasks[indexPath.row]
        taskCell.delegate = self
        taskCell.indexOfTask = indexPath.row
        taskCell.task = task
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            AppData.tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension TasksVC: TaskCellDelegate {
    func onEnableTask(indexOfTask: Int, isEnable: Bool) {
        let indexOfSelected = selectedTasks.index(of: indexOfTask)
        if isEnable {
            if indexOfSelected == nil {
                selectedTasks.append(indexOfTask)
            }
        }else{
            if indexOfSelected != nil {
                selectedTasks.remove(at: indexOfSelected!)
            }
        }
    }
}
