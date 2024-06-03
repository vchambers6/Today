//
//  ReminderListViewController+Actions.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/26/24.
//

import UIKit

extension ReminderListViewController {
    
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        #warning("Question: I was really confused at first, because the way it's set up, I thought that onChange would be called immediately, and we would add an empty reminder to the reminders list when calling the .addReminder function.")
        #warning("Answer: If you look in ReminderViewController, on the reminder property, the onChange function in the didSet property observer is called every time reminder changes EXCEPT DURING INITIALIZATION. Therefore, this setup works, because the only case where reminder changes is if we press the Done button, which updates reminder to be equal to workingReminder and changes the value of it, triggering the onChage function -- this happens in the preapareForViewing() function.")
        let viewController = ReminderViewController(reminder: reminder) {[weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        #warning("INFO: present modally presents a view controller")
        present(navigationController, animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        updateSnapshot()
    }
}
