//
//  ViewController.swift
//  Notes App
//
//  Created by JPL-ST-SPRING2022 on 12/12/22.
//

struct NoteElement: Codable{
    let title: String
    let note: String
    let date: Date
}

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store: StoreType = CoreDataStore()
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet var searchBar: UITextField!
    
    var models: [NoteElement] = []
    var showIndecies: [Int] = []
    
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
        showIndecies = []
        for i in 0 ... models.count {
            showIndecies.append(i)
        }
        title = "Notes"
    }
    
    func setAllShowIndecies() {
        showIndecies = []
        for i in 0 ... models.count {
            showIndecies.append(i)
        }
        searchBar.text = ""
        self.table.reloadData()
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: Any) {
        guard var text = searchBar.text else {
            setAllShowIndecies()
            return
        }
        if text == "" {
            setAllShowIndecies()
            return
        }
        var indecies: [Int] = []
        text = text.lowercased()
        var i = 0
        for cell in models {
            let title = cell.title.lowercased()
            let note = cell.note.lowercased()
            if (title.contains(text) || note.contains(text)) {
                indecies.append(i)
            }
            i += 1
        }
        showIndecies = indecies
        self.table.reloadData()
    }
    
    @IBAction func didTapNewNote () {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {
                    noteTitle, note in self.navigationController?.popToRootViewController(animated: true)
                    let thisNote = NoteElement(title:noteTitle,note:note,date: .now)
                    self.models.append(thisNote)
                    self.label.isHidden = true
                    self.table.isHidden = false
                    self.setAllShowIndecies()
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, hh:mm"
        let thisDate = dateFormatter.string(from: models[indexPath.row].date)
        cell.textLabel?.text = models[indexPath.row].title + " (" + thisDate + ")"
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showIndecies.contains(indexPath.row) {
            return UITableView.automaticDimension
        } else {
            return 0
        }
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
        vc.date = model.date
        vc.deleteNote = {
            noteTitle, note, date in self.navigationController?.popToRootViewController(animated: true)
            let thisNote = NoteElement(title:noteTitle,note:note,date: date)
            do {
                try self.store.remove(thisNote)
            } catch {
                NSLog("Error deleteing note.")
            }
            self.models.remove(at: indexPath.row)
            self.showIndecies = self.showIndecies.filter {$0 != indexPath.row}
            self.setAllShowIndecies()
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

