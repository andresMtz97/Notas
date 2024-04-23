//
//  NotesManager.swift
//  Notas
//
//  Created by DISMOV on 19/04/24.
//

import Foundation

class NotesManager {
    static let shared = NotesManager()
    
    private var notes: [Note] = []
    
    private init() {
        loadNotes()
    }
    
    func createNote(note: Note) {
        notes.append(note)
    }
    
    func getNotes() -> [Note] {
        return notes
    }
    
    func getNote(at index: Int) -> Note {
        return notes[index]
    }
    
    func updateNote(at index: Int, note: Note) {
        notes[index] = note
    }
    
    func deleteNote(at index: Int) {
        notes.remove(at: index)
    }
    
    func countNotes() -> Int {
        return notes.count
    }
    
    func saveNotes() {
        // Save json file
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("DD: ", documentsDirectory)
        
        //v1
        let notesUrl = documentsDirectory.appendingPathComponent("notes.json")
        print("notesURL: ", notesUrl)
        
        //v2
        let notesUrl2 = documentsDirectory.appending(path: "notes.json")
        print("notesURL2: ", notesUrl2)
        
        do {
            let jsonData = try JSONEncoder().encode(notes)
            fileManager.createFile(atPath: notesUrl2.path, contents: jsonData)
        } catch let error {
            print(error)
        }
    }
    
    func loadNotes() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let notesUrl = documentsDirectory.appending(path: "notes.json")
        
        if fileManager.fileExists(atPath: notesUrl.path()) {
            do {
                let jsonData = fileManager.contents(atPath: notesUrl.path())
                notes = try JSONDecoder().decode([Note].self, from: jsonData!)
            } catch let error {
                print(error)
            }
        } else {
            print("No se localizó el archivo")
        }
    }
}
