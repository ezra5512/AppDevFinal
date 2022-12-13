//
//  ViewController.swift
//  Notes App
//
//  Created by JPL-ST-SPRING2022 on 12/12/22.
//

struct NoteElement: Codable{
    let title: String
    let note: String
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store: StoreType = CoreDataStore()
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var models: [NoteElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        do {
            let elements = try store.fetchAll()
            models = elements
        } catch {
            NSLog("Error retrieving notes.")
        }
        title = "Notes"
    }
    
    @IBAction func didTapNewNote () {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {
                    noteTitle, note in self.navigationController?.popToRootViewController(animated: true)
                    let thisNote = NoteElement(title:noteTitle,note:note)
                    self.models.append(thisNote)
                    self.label.isHidden = true
                    self.table.isHidden = false
                    do {
                        try self.store.store(thisNote)
                    } catch {}
                    self.table.reloadData()
                }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapDelete () {
        guard let vc = storyboard?.instantiateViewController(identifier: "delete") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {
                    noteTitle, note in self.navigationController?.popToRootViewController(animated: true)
                    let thisNote = NoteElement(title:noteTitle,note:note)
                    self.models.append(thisNote)
                    self.label.isHidden = true
                    self.table.isHidden = false
                    do {
                        try self.store.store(thisNote)
                    } catch {}
                    self.table.reloadData()
                }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = models[indexPath.row]
        
        //note controller show
        
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.title
        vc.note = model.note
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

