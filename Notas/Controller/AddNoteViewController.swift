//
//  AddNoteViewController.swift
//  Notas
//
//  Created by DISMOV on 20/04/24.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var notesManager = NotesManager.shared
    
    var note: Note? = nil
    var notePosition: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let position = notePosition {
            note = notesManager.getNote(at: position)
            noteTitle.text = note?.title
            noteContent.text = note?.content
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NotesViewController
        if note == nil {
            note = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        } else {
            note?.title = noteTitle.text ?? ""
            note?.content = noteContent.text ?? ""
            destination.notePosition = notePosition
        }
        
        destination.note = note
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Validate note info
        return true
    }

    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        let isModal = self.presentingViewController is UINavigationController
        if isModal {
            self.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
