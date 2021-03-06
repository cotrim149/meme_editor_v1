//
//  ViewControllerExtension.swift
//  meme_editor_v1
//
// This methods was found in: https://newfivefour.com/swift-ios-xcode-resizing-on-keyboard.html

import UIKit

extension UIViewController  {

	@objc func keyboardWillShowForResizing(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
			let window = self.view.window?.frame {
			// We're not just minusing the kb height from the view height because
			// the view could already have been resized for the keyboard before

			let toolbarHeigh : CGFloat = 44
			
			self.view.frame = CGRect(x: self.view.frame.origin.x,
			                         y: self.view.frame.origin.y,
			                         width: self.view.frame.width,
			                         height: window.origin.y + window.height + toolbarHeigh - keyboardSize.height)
			
		} else {
			debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
		}
	}
	
	@objc func keyboardWillHideForResizing(notification: Notification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			let viewHeight = self.view.frame.height
			let toolbarHeigh : CGFloat = 44

			self.view.frame = CGRect(x: self.view.frame.origin.x,
			                         y: self.view.frame.origin.y,
			                         width: self.view.frame.width,
			                         height: viewHeight + keyboardSize.height - toolbarHeigh)
		} else {
			debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
		}
	}
	
	func setupViewResizerOnKeyboardShown() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(UIViewController.keyboardWillShowForResizing),
		                                       name: Notification.Name.UIKeyboardWillShow,
		                                       object: nil)
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(UIViewController.keyboardWillHideForResizing),
		                                       name: Notification.Name.UIKeyboardWillHide,
		                                       object: nil)
	}
}
