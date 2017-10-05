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

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if memeImage.image == nil {
			shareSocialMediaButton.isEnabled = false
			cancelPhotoEditionButton.isEnabled = false
		}
	}
	
	
}

// MARK: - Button Actions
extension ViewController {

	@IBAction func share(_ sender: UIBarButtonItem) {
		
	}
	@IBAction func cancelPhotoEdition(_ sender: Any) {
	}
	@IBAction func openCamera(_ sender: UIBarButtonItem) {
	}
	@IBAction func openAlbum(_ sender: UIBarButtonItem) {
	}
}
