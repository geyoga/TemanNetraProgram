//
//  ArsipViewController.swift
//  TemanNetraProgram
//
//  Created by Linando Saputra on 26/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import AVFoundation



class ArsipViewController: UIViewController {

//    var judulNotes: [String] = []
//    var isiNotes: [String] = []
//    var timestampNotes: [Int] = []
//    var tableRowCounter = 0
    var notes:[Note] = []
    var searchedNotes: [Note] = []
    var counterJudul = 0
   
    
    @IBOutlet weak var arsipTableView: UITableView!
    //var searchDictionary: [String: [Int: String]] = [:]
    //var tempDictionary: [Int: String] = [:]
    //var searchJudul: [String: [Int: String]] = [:]
//    var searchJudul = [String]()
//    var searchTimestamp = [Int]()
    //var searchTimestamp: [Int: String] = [:]
    var searching = false
    
//    var titleSelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.stopSpeaking(at: .immediate)
        
        self.navigationItem.title = "Arsip"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }

    func fetchData()
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return  }
        
        notes = []
        
        do {
            notes = try managedContext.fetch(Note.fetchRequest())
            arsipTableView.reloadData()
//            for note in notes
//            {
////                judulNotes[tableRowCounter] = note.judulNotes!
////                isiNotes[tableRowCounter] = note.isiNotes!
////                timestampNotes[tableRowCounter] = Int(note.timestampNotes)
////                tempDictionary.updateValue(note.isiNotes!, forKey: Int(note.timestampNotes))
////                searchDictionary.updateValue(tempDictionary, forKey: note.judulNotes!)
//                judulNotes.append(note.judulNotes!)
//                isiNotes.append(note.isiNotes!)
//                timestampNotes.append(Int(note.timestampNotes))
//                tableRowCounter+=1
//            }
        } catch  {
            print("Gagal memanggil")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArsipToDetail"
        {
            let destination = segue.destination as! DetailViewController
            destination.note = sender as! Note
//            destination.titleNote = self.titleSelected
        }
    }
}



extension ArsipViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchedNotes.count
        }else 
        {
            return notes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArsipCell") as! ArsipCell
        if searching
        {
//            cell.judulArsip.text = searchJudul.keys.first
//            searchTimestamp = searchJudul.values.first!
//            cell.timestampNote.text = String(searchTimestamp.keys.first!)
//            searchJudul.removeValue(forKey: searchJudul.keys.first!)
            cell.judulArsip.text = searchedNotes[indexPath.row].judulNotes
            
            
            
        }
        else
        {
            cell.judulArsip.text = notes[indexPath.row].judulNotes
           // cell.timestampNote.text = String(notes[indexPath.row].timestampNotes)
            cell.timestampNote.text = date().string(from: notes[indexPath.row].timestampNotes ?? Date())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.titleSelected = notes[indexPath.row].judulNotes
        if searching
        {
            performSegue(withIdentifier: "ArsipToDetail", sender: searchedNotes[indexPath.row])
        }else{
            performSegue(withIdentifier: "ArsipToDetail", sender: notes[indexPath.row])
        }
    }
    
    func date() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
    
    
}

extension ArsipViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchJudul = searchDictionary.filter({$0.key.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        searchJudul = judulNotes.filter({$0.lowercased().contains(searchText.lowercased())})
//        searchJudul = judulNotes.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        if(searchText == "")
        {
            fetchData()
            print("masuk sini")
            searching = false
            searchBar.text = ""
            
        }
        else
        {
        searchedNotes = notes.filter{($0.judulNotes?.lowercased().contains(searchText.lowercased()))!}
        searching = true
        arsipTableView.reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        arsipTableView.reloadData()
    }
}
