//
//  EasyPicker.swift
//  MJEasyPicker
//
//  Created by Mark Jerde on 3/20/18.
//  Copyright © 2018 Mark Jerde.
//
//  This file is part of MJEasyPicker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of MJEasyPicker and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

/// The delegate for the EasyPicker view.
protocol EasyPickerDelegate: class {
	/// Called by the EasyPicker when a value has been picked.
	///
	/// - Parameter picker: The EasyPicker in which a value was picked.
	func didPick(forPicker picker: EasyPicker)
}

/// An object that displays a pickable text area in your interface.
@IBDesignable class EasyPicker : UITextField, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

	// IB will only display IBInspectable properties if they are within a small set of types, not including NSTextAlignment or UITextBorderStyle.  As a result, we can get those in IB by putting Int proxies for them in.  The proxies will not display in IB unless we specify their type.
	// There seems to be no way for IB to deal with the base class properties that these are redefining other than replace them in this manner and just ignore the base class entries in Attribute Inspector that won't do anything now.

	/// The color of the text that is touched to open the picker.
	@IBInspectable public var color:UIColor = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0) {
		didSet {
			textColor = color
		}
	}

	/// The alignment of the text that is touched to open the picker.  Use NSTextAlignment rawValue.
	@IBInspectable public var alignment:Int = NSTextAlignment.right.rawValue {
		didSet {
			textAlignment = NSTextAlignment(rawValue: alignment)!
		}
	}

	/// The border of the text that is touched to open the picker.  Use UITextBorderStyle rawValue.
	@IBInspectable public var border:Int = UITextBorderStyle.none.rawValue {
		didSet {
			borderStyle = UITextBorderStyle(rawValue: border)!
		}
	}

	/// The options for the picker to display, in the order they will be displayed.
	public var options:[String] = []

	/// A delegate to be informed when a value is picked.
	public var easyPickerDelegate:EasyPickerDelegate? = nil

	// MARK: - Non-public Members

	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		setup()
	}

	/// Called by Interface Builder to allow correct drawing.
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setupCommon()
	}

	/// Setup elements needed by Interface Builder as well as normal use.
	func setupCommon() {
		textColor = color
		textAlignment = NSTextAlignment(rawValue: alignment)!
		borderStyle = UITextBorderStyle(rawValue: border)!
		tintColor = UIColor.clear // This will always be clear, since otherwise there will be a visible cursor when the picker is open.
	}

	/// Run-time setup items.
	func setup() {
		picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
		pickerInputView = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))

		setupCommon()

		let tintColor: UIColor = UIColor(red: 101.0/255.0, green: 98.0/255.0, blue: 164.0/255.0, alpha: 1.0)
		adjustFrame()
		if let picker = picker {
			picker.tintColor = tintColor
			pickerInputView?.addSubview(picker) // add picker to UIView

			picker.delegate = self
			picker.dataSource = self
		}

		inputView = pickerInputView
		delegate = self
	}

	// TODO: It might be possible to put the UIPickerView and containing UIView in static members and share them to reduce resource consumption.

	/// The UIPickerView allowing use of a picker.
	private var picker: UIPickerView? = nil

	/// The UIView that contains the picker.
	private var pickerInputView: UIView? = nil

	// The text field was touched and the picker will open.
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// Move the picker to reflect the current value.
		if let text = text {
			if let index = options.index(of: text) {
				picker?.selectRow(index,
								  inComponent: 0,
								  animated: false)
			}
		}
	}

	// The frame of the view.
	override var frame: CGRect {
		didSet {
			// Respond to rotation and screen split.
			// TODO: Support for Split View needs to be tested.
			adjustFrame()
		}
	}

	/// Adjusts the picker's frame in response to changing view frame.
	private func adjustFrame() {
		if let superview = superview {
			if let pickerInputView = pickerInputView {
				// TODO: The hard-coded height may be incorrect in 1x and 4x environments.
				pickerInputView.frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: 240)
				picker?.center.x = pickerInputView.center.x
			}
		}
	}

	// The number of columns of data.
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	// The number of rows of data.
	func pickerView(_ pickerView: UIPickerView,
					numberOfRowsInComponent component: Int) -> Int {
		return options.count
	}

	// The data to return for the row and component (column) that's being passed in.
	func pickerView(_ pickerView: UIPickerView,
					titleForRow row: Int,
					forComponent component: Int) -> String? {
		return options[row]
	}

	// The selection picked.
	func pickerView(_ pickerView: UIPickerView,
					didSelectRow row: Int,
					inComponent component: Int) {
		if ( isEditing ) {
			text = options[row]
			easyPickerDelegate?.didPick(forPicker: self)
		}
	}

}
