//
//  NoteViewController.swift
//  Notes App


import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    @IBOutlet var dateLabel: UILabel!
    
    public var noteTitle: String = ""
    public var note: String = ""
    public var date: Date = .now
    
    public var deleteNote: ((String,String,Date)->Void)?
    
    override func viewDidLoad() {
            super.viewDidLoad()
            titleLabel.text = noteTitle
            noteLabel.text = note
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY, MMM d, hh:mm"
            let thisDate = dateFormatter.string(from: date)
            dateLabel.text = "created: " + thisDate
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete))
    }
    
    @objc func didTapDelete() {
        deleteNote?(noteTitle,note,date)
    }
    
}
