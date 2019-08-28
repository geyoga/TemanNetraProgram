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

    var judulNotes: [String] = []
    var isiNotes: [String] = []
    var timestampNotes: [Int] = []
    var tableRowCounter = 0
    
    @IBOutlet weak var arsipTableView: UITableView!
    //var searchDictionary: [String: [Int: String]] = [:]
    //var tempDictionary: [Int: String] = [:]
    //var searchJudul: [String: [Int: String]] = [:]
    var searchJudul = [String]()
    var searchTimestamp = [Int]()
    //var searchTimestamp: [Int: String] = [:]
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.stopSpeaking(at: .immediate)
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
        
        var notes = [Note]()
        
        do {
            notes = try managedContext.fetch(Note.fetchRequest())
            
            for note in notes
            {
//                judulNotes[tableRowCounter] = note.judulNotes!
//                isiNotes[tableRowCounter] = note.isiNotes!
//                timestampNotes[tableRowCounter] = Int(note.timestampNotes)
//                tempDictionary.updateValue(note.isiNotes!, forKey: Int(note.timestampNotes))
//                searchDictionary.updateValue(tempDictionary, forKey: note.judulNotes!)
                judulNotes.append(note.judulNotes!)
                isiNotes.append(note.isiNotes!)
                timestampNotes.append(Int(note.timestampNotes))
                tableRowCounter+=1
            }
        } catch  {
            print("Gagal memanggil")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArsipToDetail"
        {
            let destination = segue.destination as! DetailViewController
            destination.detailNote = sender as! String
        }
    }
}



extension ArsipViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return searchJudul.count
        }else
        {
            return tableRowCounter
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
            cell.judulArsip.text = searchJudul[indexPath.row]
            cell.timestampNote.text = String(timestampNotes[indexPath.row])
        }
        else
        {
            cell.judulArsip.text = judulNotes[indexPath.row]
            cell.timestampNote.text = String(timestampNotes[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ArsipToDetail", sender: isiNotes[indexPath.row])
    }
}

extension ArsipViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchJudul = searchDictionary.filter({$0.key.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searchJudul = judulNotes.filter({$0.lowercased().contains(searchText.lowercased())})
//        searchJudul = judulNotes.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        arsipTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        arsipTableView.reloadData()
    }
}
