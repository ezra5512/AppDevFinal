//
//  NoteViewController.swift
//  Notes App


import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    public var noteTitle: String = ""
    public var note: String = ""
    
    override func viewDidLoad() {
            super.viewDidLoad()
            titleLabel.text = noteTitle
            noteLabel.text = note
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(didTapDelete))
    }

}
