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
    @IBOutlet weak var font: UIPickerView!
    @IBOutlet weak var color: UIColorWell!
    
    var notesManager = NotesManager.shared
    
    var note: Note? = nil
    var notePosition: Int?
    
    let fontFamilyData = UIFont.familyNames.prefix(30)
    var currentFont: UIFont? = nil
    var currentColor = [CGFloat(1.0), CGFloat(1.0), CGFloat(1.0), CGFloat(1.0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        currentFont = UIFont(name: fontFamilyData[0], size: 14.0)
        
        font.delegate = self
        font.dataSource = self
                
        noteContent.delegate = self
        noteContent.text = "Note Content"
        noteContent.textColor = .lightGray

        // Do any additional setup after loading the view.
        if let position = notePosition {
            note = notesManager.getNote(at: position)
            
            currentFont = UIFont(name: note!.font, size: 14.0)
            currentColor = note!.color
            
            noteTitle.text = note?.title
            noteContent.text = note?.content
            if !(note?.content ?? "").isEmpty { noteContent.textColor = .label }
        }
        
        noteTitle.font = currentFont
        noteContent.font = currentFont
                
        font.selectRow(fontFamilyData.firstIndex(of: currentFont!.familyName)!, inComponent: 0, animated: false)
        
        color.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        color.selectedColor = UIColor(red: currentColor[0], green: currentColor[1], blue: currentColor[2], alpha: currentColor[3])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NotesViewController
        if note == nil {
            note = Note(
                title: noteTitle.text ?? "",
                content: noteContent.text,
                date: Date(),
                font: currentFont!.familyName,
                color: currentColor
            )
        } else {
            note?.title = noteTitle.text ?? ""
            if noteContent.text == nil || noteContent.text == "Note Content" {
                note?.content = ""
            } else {
                note?.content = noteContent.text
            }
            note?.font = currentFont!.familyName
            note?.color = currentColor
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
    
    @objc func colorChanged(){
        currentColor = (color.selectedColor?.cgColor.components!)!
    }
}
