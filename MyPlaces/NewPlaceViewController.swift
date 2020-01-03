//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Kirill Parhomenko on 1.1.2020.
//  Copyright © 2020 Kirill Parhomenko. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var imageOfPlace: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
//    MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImgPicker(source: .camera)
                
            }
            let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImgPicker(source: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: Text field delegate
extension NewPlaceViewController: UITextFieldDelegate {
//    Hide keyboard by pressing "Done"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        imageOfPlace.image = info[.editedImage] as? UIImage
        imageOfPlace.contentMode = .scaleAspectFill
        imageOfPlace.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
