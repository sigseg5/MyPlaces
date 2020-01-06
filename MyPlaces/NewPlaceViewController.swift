//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Kirill Parhomenko on 1.1.2020.
//  Copyright © 2020 Kirill Parhomenko. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var imageIsChanged = false
    
    var newPlace = Place()

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
//    MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImgPicker(source: .camera)
                
            }
            cameraAction.setValue(cameraIcon, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImgPicker(source: .photoLibrary)
            }
            photoAction.setValue(photoIcon, forKey: "image")
            photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewPlace() {
        var newImage: UIImage?
        
        if imageIsChanged {
            newImage = placeImage.image
        } else {
            newImage = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
//        newPlace = Place(name: placeName.text!,
//                         location: placeLocation.text,
//                         type: placeType.text,
//                         image: newImage,
//                         restaurantImage: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Text field delegate
extension NewPlaceViewController: UITextFieldDelegate {
//    Hide keyboard by pressing "Done"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldChanged() {
        if placeName.text?.isEmpty == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

// MARK: work with img
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImgPicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true, completion: nil)
    }
}
