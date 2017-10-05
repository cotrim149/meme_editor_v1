//
//  UIAlertControllerExtension.swift
//  meme_editor_v1
//
//  Created by Victor de Lima on 05/10/17.
//  Copyright © 2017 Victor de Lima. All rights reserved.
//

import UIKit

extension UIAlertController {

	func alert(withTitle title:String?,message:String?,andActions actions:[UIAlertAction], inController controller:UIViewController?) {
		
		guard let controller = controller else {
			return
		}
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		for action in actions {
			alert.addAction(action)
		}
		
		controller.present(alert, animated: true, completion: nil)
	}
}
