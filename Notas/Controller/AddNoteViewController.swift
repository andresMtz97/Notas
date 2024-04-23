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
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var notesManager = NotesManager.shared
    
    var note: Note? = nil
    var notePosition: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteContent.delegate = self
        noteContent.text = "Note content"
        noteContent.textColor = .lightGray
        

        // Do any additional setup after loading the view.
        if let position = notePosition {
            note = notesManager.getNote(at: position)
            noteTitle.text = note?.title
            noteContent.text = note?.content
            if !(note?.content ?? "").isEmpty { noteContent.textColor = .label }
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
            if noteContent.text == nil || noteContent.text == "Note Content" {
                note?.content = ""
            } else {
                note?.content = noteContent.text
            }
            destination.notePosition = notePosition
        }
        
        destination.note = note
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Validate note info
        let title = noteTitle.text ?? ""
        let content = noteContent.text ?? ""
        
        if !title.isEmpty && !content.isEmpty && content != "Note Content" {
            return true
        }
        
        let alert = UIAlertController(title: "Error", message: "Title and Note content are required.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
        
        return false
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

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note Content"
            textView.textColor = .lightGray
        }
    }
}
