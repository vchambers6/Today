//
//  ReminderViewController.swift
//  Today-Sample-Project
//
//  Created by Vanessa Chambers on 5/27/24.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    private var dataSource: DataSource!
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    
    var workingReminder: Reminder
    var isAddingNewReminder: Bool = false
    var onChange: (Reminder) -> Void
    
    #warning("INFO: @esccaping attribute is used to indicuate that a closure passed as an argument may be called after the function returns. In this case, we call onChange when reminder changes, after the initializer has already returned.")
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        #warning("INFO: collection views don't include section headers by default, so we need to change the config's header mode.")
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        super.init(collectionViewLayout: listLayout)
    }
    
    #warning("INFO: this is necessary so that the system can initialize the view controller using an archive because IB stores archives of view controllers we create")
    #warning("NSCoding requires a failable initializer -- but because we create views only programataically, app does not use this initializer")
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UICollectiolViewController using init(reminder: Reminder)")
    }
    
    
    #warning("INFO: we need to override the superclass viewdidLoad if we want to do other things in the view controller's lifecycle, like register the cell with the collection view + create the data source")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        #warning("INFO: this is how you check for a certain os availability. Also, .navigator style places title in the center and back button on the left")
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        #warning("INFO: UIViewController's setEditing method displays Done in the navigation bar when in editing mode and Edit when in view mode.")
        super.setEditing(editing, animated: animated)
        
        if editing {
            prepareforEditing()
        } else {
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareforViewing()
            }
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        
        let section = section(for: indexPath)
        
        switch (section, row) {
        case (_, .header(let title)):
            
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            /// Cell content configuration
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration  = notesConfiguration(for: cell, with: notes)
            
        default:
            fatalError("Unexpcted combination of section and row")
        }
        
        /// Other UI properties of cell
        cell.tintColor = .todayPrimaryTint
    }
    
    private func updateSnapshotForViewing() {
        /// default snapshot instance
        var snapshot = Snapshot()
        /// add 0th section to snapshot -- the only section we are using
//        snapshot.appendSections([0])
        /// now that we've changed the datasource alias to Snapshot, we need to append the .view section instead
        snapshot.appendSections([.view])
        #warning("INFO: inserting empty header item as first element -- this is the header for view (we don't need one) -- the header is the first item in the section in either case.")
        snapshot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    func prepareforViewing() {
        if reminder != workingReminder {
            reminder = workingReminder
        }
        navigationItem.leftBarButtonItem = nil
        updateSnapshotForViewing()
    }
    
    func prepareforEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    @objc func didCancelEdit() {
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    #warning("INFO: in view mode, all sections are displayed in section 0. in editing mode, title, date, and ntoes are separated into sections 1, 2, and 3. (hence the int and hashable type)")
    func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section at \(sectionNumber)")
        }
        
        return section
    }
    
}
