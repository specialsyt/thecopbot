//
//  ProfilesVC.swift
//  Copbot
//
//  Created by Admin on 3/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProfilesVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkDefaultProfile()
        tableView.reloadData()
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
    
    func setDefaultProfile(profileIndex: Int) {
        if AppData.profiles.count > 0 {
            for index in 0...AppData.profiles.count - 1 {
                if index == profileIndex {
                    AppData.profiles[profileIndex]["default"] = "yes"
                }else{
                    AppData.profiles[index]["default"] = "no"
                }
            }
        }
    }
    
    func checkDefaultProfile() {
        if AppData.profiles.count > 0 {
            if let index = AppData.profiles.firstIndex(where: {$0["default"] == "yes"}) {
                setDefaultProfile(profileIndex: index)
            }else{
                AppData.profiles[0]["default"] = "yes"
            }
        }
    }
}

extension ProfilesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let profile = AppData.profiles[indexPath.row]
        profileCell.delegate = self
        profileCell.indexOfProfile = indexPath.row
        profileCell.profile = profile
        return profileCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = STORYBOARD.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        editVC.editingIndex = indexPath.row
        self.show(editVC, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            AppData.profiles.remove(at: indexPath.row)
            self.checkDefaultProfile()
            tableView.reloadData()
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension ProfilesVC: ProfileCellDelegate {
    func onDefaultSwitch(indexOfProfile: Int, isOn: Bool) {
        if isOn {
            setDefaultProfile(profileIndex: indexOfProfile)
        }else{
            checkDefaultProfile()
        }
        tableView.reloadData()
    }
}
