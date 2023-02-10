//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 10.02.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    @IBOutlet weak var imageOfPlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Table view delegate
    
    // Skryvaem klaviaturu po najatiyu za predelami klaviatury
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // eli index = 0 (kartinka) to nichego ne delaem
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet) // sozdaem AlertController s nijnim menyu
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in // knopka kamera
                self.chooseImagePicker(source: .camera)
            }
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in // knopka photo
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) // knopka cancel
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true)
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

// MARK: - Work with image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerController - upravlyaet interfeisami dlya s'emki foto, zapisi video, ivybor izobrajeniya iz mediateki pol'zovatelya
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            self.present(imagePicker, animated: true)
        }
    }
    
    // Dobavit' foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // pozvolyaet ispol'zovat' otredektirovannoe pol'zovatelem izobrajenie
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFill // pozvalyaem redektorovat' izobrajenie po soderjimomu UIImage
        imageOfPlace.clipsToBounds = true // obrezka po granicam UIImage
        dismiss(animated: true) // zakryt' ImagePickerController
    }
}
