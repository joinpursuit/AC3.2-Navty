//
//  ContactsTableViewController.swift
//  Navty
//
//  Created by Miti Shah on 3/2/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//
import UIKit
import Contacts
import ContactsUI

class ContactsTableViewController: UITableViewController, CNContactPickerDelegate {
    
    var contactStore = CNContactStore()
    var contacts = [CNContact]()
    var userDefaults = UserDefaults.standard
    var userIdentifier = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        //        tableView.rowHeight = 100
        
        //        tableView.emptyDataSetSource = self
        //        tableView.emptyDataSetDelegate = self
        //
        //        self.navigationController?.isToolbarHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
        let barButton = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        //        let toolEditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: "addSomething:")
        //        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),toolEditButton]
        //        self.navigationController?.setToolbarHidden(false, animated: false)
        
        DispatchQueue.main.async {
            self.tableView!.reloadData()
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        guard contacts.count <= 5 else { addButton.isEnabled = false; addButton.alpha = 0.5; return }
        
        contacts.removeAll()
        let arrOfIdentifiers = userDefaults.object(forKey: "identifierArr") as? Array<String>
        
        for contact in userDefaults.dictionaryRepresentation()  {
            if let array = arrOfIdentifiers{
                userIdentifier = array
                for identifier in userIdentifier {
                    if contact.key == identifier {
                        let unarchived = NSKeyedUnarchiver.unarchiveObject(with: contact.value as! Data) as? CNContact
                        contacts.append(unarchived!)
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didFetchContacts(contacts: [CNContact]) {
        
        for contact in contacts {
            let uuid = "\(contact.identifier )"
            userIdentifier.append(uuid)
            let test = archiveContact(contact: contact)
            
            userDefaults.set(userIdentifier, forKey: "identifierArr")
            userDefaults.set(test, forKey: uuid)
            
        }
        
    }
    
    func archiveContact(contact:CNContact) -> Data {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: contact) as NSData
        return archivedObject as Data
    }
    
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ContactTableViewCell
        
        
        let contact = self.contacts[indexPath.row]
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        
        
        if contact.phoneNumbers.count > 0 {
            let MobNumVar = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
            cell.phoneLabel.text = MobNumVar
        }
        
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let path = indexPath.row
            let arrOfIdentifiers = userDefaults.object(forKey: "identifierArr") as? Array<String>
            
            let removeIdentifier = userIdentifier[path]
            
            for _ in arrOfIdentifiers! {
                userDefaults.removeObject(forKey: removeIdentifier)
            }
            
            contacts.remove(at: path)
            userIdentifier.remove(at: path)
            
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            //            guard contacts.count < 5 else { addButton.isEnabled = false; addButton.alpha = 0.5; return }
        }
        
    }
    
    
    // MARK: - Contacts Picker
    
    func showContactsPicker(_ sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        //        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        let predicate = NSPredicate(value: false)
        let truePredicate = NSPredicate(value: true)
        contactPicker.predicateForSelectionOfContact = predicate
        contactPicker.predicateForSelectionOfProperty = truePredicate
        
        
        self.present(contactPicker, animated: true, completion: nil)
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        self.didFetchContacts(contacts: [contact])
    }
    
    
    
    lazy var addButton:  UIButton = {
        let button = UIButton(type: UIButtonType.contactAdd)
        button.addTarget(self, action: #selector(showContactsPicker), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return button
    }()
    
    lazy var editButton:  UIButton = {
        let button = UIButton(type: UIButtonType.contactAdd)
        //button.addTarget(self, action: #selector(showContactsPicker), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return button
    }()
    
}
