//
//  MemeEditorVC.swift
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

class MemeEditorVC: UIViewController {

	enum TextFieldTag: Int {
		case top = 1
		case bottom = 2
	}
	
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
		
		customizeTextField(textField: topTextField, defaultText: "TOP", withTag: .top)
		customizeTextField(textField: bottomTextField, defaultText: "BOTTOM", withTag: .bottom)
		
		self.setupViewResizerOnKeyboardShown()
	}
	
	func customizeTextField(textField: UITextField, defaultText: String, withTag tag: TextFieldTag) {
		let fontSize : CGFloat = 40
		let strokeWidth = -5
		
		let memeTextAttributes:[String:Any] = [
			NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
			NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
			NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize)!,
			NSAttributedStringKey.strokeWidth.rawValue: strokeWidth
		]

		textField.defaultTextAttributes = memeTextAttributes
		textField.placeholder = defaultText
		textField.textAlignment = .center
		textField.tag = tag.rawValue
		textField.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupButtons()
		
		let fontSize = adjustFontSize(toDefaultSize: true)
		topTextField.font = UIFont.systemFont(ofSize: fontSize)
		bottomTextField.font = UIFont.systemFont(ofSize: fontSize)
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
	
	fileprivate func adjustFontSize(toDefaultSize:Bool = false) -> CGFloat {
		let defaultFontSize = CGFloat(40.0)
		
		// The best practices said: every "if" has an "else", but in this case the return make the obvious work
		if toDefaultSize == true {
			return defaultFontSize
		}
		
		guard let imageSize = self.memeImage.image?.size else {
			return defaultFontSize
		}

		var gain : CGFloat = 1.0
		var imageSizeOrientation : CGFloat = 1.0
		var screenSizeOrientation : CGFloat = 1.0
		
		if UIApplication.shared.statusBarOrientation.isPortrait {
			imageSizeOrientation = imageSize.height
			screenSizeOrientation = UIScreen.main.bounds.height

			if imageSizeOrientation != screenSizeOrientation {
				gain = 1.4
			}

		} else {
			imageSizeOrientation = imageSize.width
			screenSizeOrientation = UIScreen.main.bounds.width

			if imageSizeOrientation != screenSizeOrientation {
				gain = 1.25
			}
		}
		
		return ((defaultFontSize*imageSizeOrientation)/screenSizeOrientation)*gain
		
	}
	
	func getImageToShare() -> UIImage? {
		
		guard let imageSize = self.memeImage.image?.size else {
			return nil
		}
		
		UIGraphicsBeginImageContext(imageSize)
		
		self.memeImage.image?.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))

		// text field setup
		let gain : CGFloat = 0.8
		let textFieldSize = CGSize(width: imageSize.width*gain, height: imageSize.height/4)
		let fontSize = adjustFontSize()

		// top text field
		let topTextFieldNumberOfSections : CGFloat = 20
		let topTextFieldPosition = CGPoint(x: imageSize.width/2 - textFieldSize.width/2 , y: imageSize.height/topTextFieldNumberOfSections)
		let topTextFieldFrame = CGRect(origin: topTextFieldPosition, size: textFieldSize)
		let newTopTextField = self.topTextField
		
		newTopTextField?.font = UIFont.systemFont(ofSize: fontSize)
		newTopTextField?.adjustsFontSizeToFitWidth = true
		newTopTextField?.drawText(in: topTextFieldFrame)
		
		// bottom text field
		// divide the height image in 10 parts and getting the 8th section of this
		let bottonTextFieldNumberOfSections : CGFloat = 10
		let eighthSection : CGFloat = 8
		let bottomTextFieldPosition = CGPoint(x: imageSize.width/2 - textFieldSize.width/2 , y: (imageSize.height/bottonTextFieldNumberOfSections) * eighthSection)
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
extension MemeEditorVC {

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
// This mark of Album and camera picker was copy from: http://www.oodlestechnologies.com/blogs/Open-Image-Gallery-and-Take-photo-in-Swift , and modified by me to better implement the project requirements

extension MemeEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
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

extension MemeEditorVC: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField.tag == TextFieldTag.top.rawValue {
			bottomTextField.isHidden = true
		} else {
			topTextField.isHidden = true
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.tag == TextFieldTag.top.rawValue {
			self.meme.topTitle = textField.text
			bottomTextField.isHidden = false
		} else {
			self.meme.bottomTitle = textField.text
			topTextField.isHidden = false
		}
	}
}
