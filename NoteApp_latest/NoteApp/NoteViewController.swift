//
//  NoteViewController.swift
//  Notes App


import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var noteLabel: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    public var noteTitle: String = ""
    public var note: String = ""
    public var date: Date = .now
    public var madeChanges: Bool = false
    public var origionalNote: NoteElement = NoteElement(title: "",note: "",date: .now)
    
    public var deleteNote: ((String,String,Date)->Void)?
    
    public var updateNote: ((String,String,NoteElement)->Void)?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            titleLabel.text = noteTitle
            noteLabel.text = note
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY, MMM d, hh:mm"
            let thisDate = dateFormatter.string(from: date)
            dateLabel.text = "created: " + thisDate
        
        origionalNote = NoteElement(title: noteTitle, note: note, date: date)
            
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete)),UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))]
    }
    
    @IBAction func textViewEditingDidChange(_ sender: Any) {
        self.madeChanges = true
    }
    /*
    override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("test")
        if (self.isMovingFromParent) {
            NSLog("test")
            let alert = UIAlertController(title: "Save Note", message: "Save changes?", preferredStyle: .alert)
            let yesDelete = UIAlertAction(title: "Yes", style: .cancel, handler: { button in
                self.handleSave()
            })
            let noDelete = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(noDelete)
            alert.addAction(yesDelete)
            if (
                self.origionalNote.title != self.titleLabel.text || self.origionalNote.note != self.noteLabel.text
            ) {
                present(alert, animated: true, completion: nil)
            }
        }
    }
     */
    
    @objc func didTapDelete() {
        let alert = UIAlertController(title: "Delete Note", message: "Delete this note and its contents forever.", preferredStyle: .alert)
        let yesDelete = UIAlertAction(title: "Yes", style: .cancel, handler: { button in
            self.deleteNote?(self.noteTitle,self.note,self.date)
        })
        let noDelete = UIAlertAction(title: "No", style: .default, handler: nil)
        alert.addAction(noDelete)
        alert.addAction(yesDelete)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapSave() {
        handleSave()
    }
    
    func handleSave() {
        if let text = titleLabel.text, !text.isEmpty, !noteLabel.text.isEmpty {
            updateNote?(text,noteLabel.text,self.origionalNote)
        } else {
            let alert = UIAlertController(title: "Error", message: "Note must have title and body.", preferredStyle: .alert)
            let close = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(close)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
