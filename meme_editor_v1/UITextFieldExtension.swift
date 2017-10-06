//
//  UITextFieldExtension.swift
//  meme_editor_v1
//
//  Created by Victor de Lima on 05/10/17.
//  Copyright © 2017 Victor de Lima. All rights reserved.
//

import UIKit

extension UITextField{

	@IBInspectable var placeHolderColor: UIColor? {
		get {
			return self.placeHolderColor
		}
		set {
			if let color = newValue {
				self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
			}
			
		}
	}
}
