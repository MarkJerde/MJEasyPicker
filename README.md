# MJEasyPicker

An iOS Framework making UIPickerView easy

## Purpose
UIPickerView has been in iOS for a long time, but is non-trivial for developers
to integrate in their applications.  MJEasyPicker changes this, allowing you to
have a picker that conforms to the style of Apple's own with very little effort.

## Usage
1. Add a Text Field in Interface Builder.
2. Open the Identity inspector and under Custom Class set Class to EasyPicker.
3. Add a Referencing Outlet from your new EasyPicker to your View Controller.
4. In your View Controller, set the options for your EasyPicker.  e.g. `languagePicker.options = ["Objective C","Swift"]`
5. Optionally, become an EasyPickerDelegate delegate to the picker.  e.g. `languagePicker.options.easyPickerDelegate = self`
6. Ensure that the picker will close when you tap outside of it, as Apple's use does, by adding this to your View Controller:

```
override func touchesBegan(_ touches: Set<UITouch>,
                          with event: UIEvent?) {
	view.endEditing(true)
}
```


## Code Notes
The integration into Interface Builder is less than ideal but far more than nonexistent.  This seems to be filled out to the extent possible in Xcode.

The touchesBegan method has to be outside of EasyPicker, even though it would be nice to have it rolled in.

## Work Items
* The hard-coded height may be incorrect in 1x and 4x environments
* Support for Split View needs to be tested.
* It might be possible to put the UIPickerView and containing UIView in static members and share them to reduce resource consumption.
