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

	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	var picker:UIImagePickerController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.picker = UIImagePickerController()
		self.picker?.delegate = self
		topTextField.delegate = self
		bottomTextField.delegate = self
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
	
	func getImageToShare() -> UIImage? {
		UIGraphicsBeginImageContext(self.memeImage.frame.size)
		
		
		
		self.memeImage.draw(CGRect(x: 0, y: 0, width: self.memeImage.frame.width, height: self.memeImage.frame.height))

		
		
		var topTextFieldFrame = self.topTextField.frame
		topTextFieldFrame.origin.y -= 70
		self.topTextField.drawText(in: topTextFieldFrame)
		
		let bottomTextFieldFrame = self.bottomTextField.frame
//		bottomTextFieldFrame.origin.y += 70
		self.bottomTextField.drawText(in: bottomTextFieldFrame)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func share(image:UIImage?) {
		
		if let sharedImage = image {
			let activityViewController = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
			activityViewController.popoverPresentationController?.sourceView = self.view
			self.present(activityViewController, animated: true, completion: nil)
		} else {
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			UIAlertController.alert(withTitle: "Meme cannot be shared", message: "Meme failed to be rederized.", andActions: [action], inController: self)
		}
	}
}

// MARK: - Button Actions
extension ViewController {

	@IBAction func share(_ sender: UIBarButtonItem) {
		let image = getImageToShare()
		self.share(image: image)
	}
	
	@IBAction func cancelPhotoEdition(_ sender: Any) {
		self.memeImage.image = nil
		setupButtons()
	}
	@IBAction func openCamera(_ sender: UIBarButtonItem) {
		openCamera()
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
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			UIAlertController.alert(withTitle: "Camera not available", message: "Camera cannot be found.", andActions: [action], inController: self)
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

extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
}
