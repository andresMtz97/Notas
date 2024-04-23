//
//  NotesViewController.swift
//  Notas
//
//  Created by DISMOV on 19/04/24.
//

import UIKit

class NotesViewController: UITableViewController {

    @IBOutlet var notesList: UITableView!
    @IBOutlet var emptyNotesView: UIView!
    
    var notesManager = NotesManager.shared
    var note: Note?
    var notePosition: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        notesManager.loadNotes()
        
        if notesManager.countNotes() == 0 {
            emptyNotesView.isHidden = false
            notesList.backgroundView = emptyNotesView
        } else {
            emptyNotesView.isHidden = true
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesManager.countNotes()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell
        let note = notesManager.getNote(at: indexPath.row)
        cell?.title.text = note.title
        cell?.date.text = note.date.iso8601String
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noteDetailSegue", sender: self)
    }

    @IBAction func unwindToNotesViewController(_ segue: UIStoryboardSegue) {
        print("Unwind seque")
        let source = segue.source as! AddNoteViewController
        note = source.note
        
        if let position = source.notePosition {
            notesManager.updateNote(at: position, note: note!)
        } else {
            notesManager.createNote(note: note!)
        }
        
        if (notesManager.countNotes() > 0) { emptyNotesView.isHidden = true }
        
        print("#N: ", notesManager.countNotes())
        notesManager.saveNotes()
        //reload table view
        notesList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetailSegue" {
            if let destination = segue.destination as? AddNoteViewController {
                if let position = notesList.indexPathForSelectedRow?.row {
                    destination.notePosition = position
                }
            }
        }
    }

}
