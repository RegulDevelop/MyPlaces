//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 10.02.2023.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var currentPlace: Place!
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        
        // knopka saveButton nedostupna
        saveButton.isEnabled = false

        // kajdyi raz pri redoktirovanii tekstovogo polya placeName budet srabatyvat' etot metod kotoryi budet vyzyvat' metot textFieldChanged, textFieldChanged budet sledit' zapolneno tekstovoe pole ili net
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    // MARK: - Table view delegate
    
    // Skryvaem klaviaturu po najatiyu za predelami klaviatury
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { // eli index = 0 (kartinka) to nichego ne delaem
            
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet) // sozdaem AlertController s nijnim menyu
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in // knopka kamera
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image") // dobavlyaem ikonku camera
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // nadpis' camera sleva ryadom s ikonkoi
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in // knopka photo
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image") // dobavlyaem ikonku foto
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment") // nadpis' photo sleva ryadom s ikonkoi
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) // knopka cancel
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true)
        } else {
            view.endEditing(true) // esli drugoi index to skryvaem klaviaturu
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
            else { return }
        
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        
        if identifier == "showPlace" {
            
            mapVC.place.name = placeName.text!
            mapVC.place.location = placeLocation.text
            mapVC.place.type = placeType.text
            mapVC.place.imageData = placeImage.image?.pngData()
        }
     
    }
    
    // sohranit' fail
    func savePlace() {
        
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        
        let imageData = image?.pngData()

        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    // knopka cancel
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - Text field delegate

// Skryvaem klaviaturu po najatiyu na Done
extension NewPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if placeName.text?.isEmpty == false { // esli pole placeName ne pustoe
            saveButton.isEnabled = true // to knopka doljna byt' dostupna
        } else {
            saveButton.isEnabled = false // esli pustoe to nedostupna
        }
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
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill // pozvalyaem redektorovat' izobrajenie po soderjimomu UIImage
        placeImage.clipsToBounds = true // obrezka po granicam UIImage
        
        imageIsChanged = true
        
        dismiss(animated: true) // zakryt' ImagePickerController
    }
}

extension NewPlaceViewController: MapViewControllerDelegate {
    func getAddress(_ address: String?) {
        placeLocation.text = address
    }
    
    
}
