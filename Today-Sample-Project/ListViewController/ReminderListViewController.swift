//
//  ReminderListViewController.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/18/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class ReminderListViewController: UICollectionViewController {
    
    #warning("INFO: this is where the collection view gets its data from. You can either use a UICollectionViewDiffableDataSource object, or create a custom data source object by adopting the UICollectionViewDataSource protocol. Data is organized into sections, which then contain items")
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    var filteredReminders: [Reminder] {
        reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted {
            $0.dueDate < $1.dueDate
        }
    }
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    #warning("This is not in the tutorial, but bc I didn't use storyboards, I had to do this here")
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
        let listLayout = UICollectionViewCompositionalLayout.list(using: {
            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
            listConfiguration.showsSeparators = false
            listConfiguration.backgroundColor = .clear
            listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
            return listConfiguration
        }())
        
        collectionView.collectionViewLayout = listLayout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
//        let listLayout = listLayout()
//        collectionView.collectionViewLayout = listLayout
        
        self.collectionView.backgroundColor = .white
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton))
        #warning("INFO: Adding an accessibility label to the button here:")
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add butto accessibility label")
        navigationItem.rightBarButtonItem = addButton
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        
        #warning("INFO: CellRegistration specifies how to configure the content and appearance of a cell")
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
        
//        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        /// Don't want to show the item that the user tapped as selected
        return false
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        #warning("INFO: We add [weak self] to the closure's capture list to prevent the ReminderViewController from capturing and storing a strong reference to the reminder list view controller")
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        #warning("INFO: UIContextualAction objects define types of actions an app can perform when a user swipes a table row")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)
        }
        #warning("INFO: a configuraiton object associates a set of actions with a table row. In the initializer, we set the listConfiguration.trailingSwipActionsConfiguratoinProvider to the return value of this function")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}




