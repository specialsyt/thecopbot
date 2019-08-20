//
//  ReadyToCopVC.swift
//  Copbot
//
//  Created by Admin on 5/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ReadyToCopVC: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    
    var selectedTasks: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss"
            let timeStr = dateFormatter.string(from: Date())
            self.navigationItem.title = timeStr
        }.fire()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchProductsVC" {
            let dest = segue.destination as! SearchProductsVC
            dest.selectedTasks = self.selectedTasks
        }
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
}

extension ReadyToCopVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let indexOfTask = selectedTasks[indexPath.row]
        let task = AppData.tasks[indexOfTask]
        taskCell.indexOfTask = indexOfTask
        taskCell.task = task
        
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}
