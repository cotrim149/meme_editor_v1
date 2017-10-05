//
//  ViewController.swift
//  meme_editor_v1
//
//  Created by Victor de Lima on 28/09/17.
//  Copyright © 2017 Victor de Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var shareSocialMediaButton: UIBarButtonItem!
	@IBOutlet weak var cancelPhotoEditionButton: UIBarButtonItem!
	@IBOutlet weak var memeImage: UIImageView!

	var picker:UIImagePickerController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.picker = UIImagePickerController()
		self.picker?.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupButtons()
		
	}
	
	func setupButtons() {
		if memeImage.image == nil {
			shareSocialMediaButton.isEnabled = false
			cancelPhotoEditionButton.isEnabled = false
		} else {
			shareSocialMediaButton.isEnabled = true
			cancelPhotoEditionButton.isEnabled = true
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			cameraButton.isEnabled = true
		} else {
			cameraButton.isEnabled = false
		}
		
	}
	
}

// MARK: - Button Actions
extension ViewController {

	@IBAction func share(_ sender: UIBarButtonItem) {
		
	}
	@IBAction func cancelPhotoEdition(_ sender: Any) {
		self.memeImage.image = nil
		setupButtons()
	}
	@IBAction func openCamera(_ sender: UIBarButtonItem) {
	}

	@IBAction func openAlbum(_ sender: UIBarButtonItem) {
		self.openAlbum()
	}
}

// MARK: - Album and Camera delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func openAlbum(){
		guard let picker = self.picker else {
			return
		}
		picker.allowsEditing = false
		picker.sourceType = .photoLibrary
		present(picker, animated: true, completion: nil)
	}
	
	func openCamera() {
		guard let picker = self.picker else {
			return
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.allowsEditing = false
			picker.sourceType = .camera
			picker.cameraCaptureMode = .photo
			present(picker, animated: true, completion: nil)
		} else {
			
		}
		
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
		self.memeImage.image = chosenImage
		self.dismiss(animated: true, completion: nil)
	}
}
