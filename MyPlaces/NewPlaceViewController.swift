//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 10.02.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view delegate
    
    // Skryvaem klaviaturu po najatiyu za predelami klaviatury
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // eli index = 0 (kartinka) to nichego ne delaem
            
        } else {
            view.endEditing(true) // esli drugoi index to skryvaem klaviaturu
        }
    }

}

// MARK: - Text field delegate

// Skryvaem klaviaturu po najatiyu na Done
extension NewPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
