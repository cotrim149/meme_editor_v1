//
//  ViewController.swift
//  meme_editor_v1
//
//  Created by Victor de Lima on 28/09/17.
//  Copyright © 2017 Victor de Lima. All rights reserved.
//

import UIKit

struct Meme {
	var topTitle: String?
	var bottomTitle: String?
	var originalImage: UIImage?
	var memeImage: UIImage?
}

class ViewController: UIViewController {

	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var shareSocialMediaButton: UIBarButtonItem!
	@IBOutlet weak var cancelPhotoEditionButton: UIBarButtonItem!
	@IBOutlet weak var memeImage: UIImageView!

	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	var picker:UIImagePickerController?
	
	var meme: Meme = Meme()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.picker = UIImagePickerController()
		self.picker?.delegate = self
		topTextField.delegate = self
		bottomTextField.delegate = self

		topTextField.tag = 1
		bottomTextField.tag = 2
		
		self.setupViewResizerOnKeyboardShown()
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
	
	fileprivate func adjustFontSize() -> CGFloat {
		let defaultFontSize = CGFloat(40.0)
		
		guard let imageSize = self.memeImage.image?.size else {
			return defaultFontSize
		}

		if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
			return (defaultFontSize*imageSize.height)/UIScreen.main.bounds.height
		} else {
			return (defaultFontSize*imageSize.width)/UIScreen.main.bounds.width
		}
		
	}
	
	func getImageToShare() -> UIImage? {
		
		guard let imageSize = self.memeImage.image?.size else {
			return nil
		}
		
		UIGraphicsBeginImageContext(imageSize)
		
		self.memeImage.image?.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

		// text field setup
		let textFieldSize = CGSize(width: imageSize.width*0.8, height: imageSize.height/4)
		let fontSize = adjustFontSize()

		// top text field
		let topTextFieldPosition = CGPoint(x: imageSize.width/2 - textFieldSize.width/2 , y: imageSize.height/20)
		let topTextFieldFrame = CGRect(origin: topTextFieldPosition, size: textFieldSize)
		let newTopTextField = self.topTextField
		
		newTopTextField?.font = UIFont.systemFont(ofSize: fontSize)
		newTopTextField?.adjustsFontSizeToFitWidth = true
		newTopTextField?.drawText(in: topTextFieldFrame)
		
		// bottom text field
		let bottomTextFieldPosition = CGPoint(x: imageSize.width/2 - textFieldSize.width/2 , y: (imageSize.height/10) * 8)
		let bottomTextFieldFrame = CGRect(origin: bottomTextFieldPosition, size: textFieldSize)

		let newBottomTextField = self.bottomTextField
		
		newBottomTextField?.font = UIFont.systemFont(ofSize: fontSize)
		newBottomTextField?.adjustsFontSizeToFitWidth = true
		newBottomTextField?.drawText(in: bottomTextFieldFrame)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		
		return img
	}
	
	func share(image:UIImage?) {
		
		if let sharedImage = image {
			meme.memeImage = sharedImage
			let activityViewController = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
			activityViewController.completionWithItemsHandler = { (type: UIActivityType?, bool: Bool, aray, error) -> Void in
				self.topTextField.font = UIFont.systemFont(ofSize: 33)
				self.bottomTextField.font = UIFont.systemFont(ofSize: 33)
			}
			
			activityViewController.popoverPresentationController?.sourceView = self.view
			self.present(activityViewController, animated: true, completion: nil)
		} else {
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			UIAlertController.alert(withTitle: "Meme cannot be shared", message: "Meme failed to be renderized.", andActions: [action], inController: self)
		}
	}
}

// MARK: - Button Actions
extension ViewController {

	@IBAction func share(_ sender: UIBarButtonItem) {
		
		DispatchQueue.main.async {
			let image = self.getImageToShare()
			self.share(image: image)
		}
		
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
		self.meme.originalImage = chosenImage
		self.dismiss(animated: true, completion: nil)
	}
}

extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.tag == 1 {
			self.meme.topTitle = textField.text
		} else {
			self.meme.bottomTitle = textField.text
		}
	}
}
