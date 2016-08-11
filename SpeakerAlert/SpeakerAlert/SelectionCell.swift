//
//  SelectionCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/8/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit
import Foundation

class SelectionCellDefinition: CellDefinition, CellWithAction {
    var title: String = ""
    var initialValue: String = ""
    var options: [String] = []
    var onChange: (String) -> () = {_ in}
    
    init(title: String, initialValue: String, options: [String], onChange: (String) -> ()) {
        self.title = title
        self.initialValue = initialValue
        self.options = options
        self.onChange = onChange
    }
    
    private var cell: SelectionCell?
    
    func performAction() {
        if let c = cell {
            c.openPicker()
            c.setSelectedValue(initialValue)
        }
    }
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "SelectionCell",
            forIndexPath: indexPath
        )
        if let c = cell as? SelectionCell {
            c.textLabel?.text = self.title
            c.detailTextLabel?.text = self.initialValue
            c.pickerData = self.options
            c.onChange = self.onChange
            self.cell = c
        }
        return cell
    }
}

class SelectionCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var picker: UIPickerView = UIPickerView()
    var pickerData: [String] = []
    var actionView: UIView = UIView()
    
    var onChange: (String) -> () = {_ in }
    
    // MARK - Picker delegate
    
    func pickerView(
        _pickerView: UIPickerView,
        titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func setSelectedValue(value: String){
        for (index, item) in pickerData.enumerate() {
            if item == value {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    func openPicker() {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        
        picker.frame = CGRect(x: 0.0, y: 44.0, width: kSCREEN_WIDTH, height: 216.0)
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.backgroundColor = UIColor.whiteColor()
        
        actionView.addSubview(setupToolbar())
        actionView.addSubview(picker)
        
        if (window) != nil {
            window!.addSubview(actionView)
        } else {
            self.superview?.addSubview(actionView)
        }
        
        self.actionView.frame = CGRect(
            x: 0,
            y: UIScreen.mainScreen().bounds.size.height,
            width: UIScreen.mainScreen().bounds.size.width,
            height: 260.0)
        
        UIView.animateWithDuration(0.2, animations: {
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.mainScreen().bounds.size.height - 260.0,
                width: UIScreen.mainScreen().bounds.size.width,
                height: 260.0)
        })
    }
    
    private func setupToolbar() -> UIView {
        let kSCREEN_WIDTH  =    UIScreen.mainScreen().bounds.size.width
        
        let pickerToolbarPadding = UIToolbar(frame:
            CGRect(
                x: 0,
                y: 0,
                width: kSCREEN_WIDTH,
                height: 44
            )
        )
        
        let pickerToolbar = UIToolbar(frame:
            CGRect(
                x: 10,
                y: 0,
                width: kSCREEN_WIDTH - 20,
                height: 44
            )
        )
        
        let barItems = buildBarItems()
        
        pickerToolbar.setItems(barItems, animated: true)
        
        pickerToolbarPadding.addSubview(pickerToolbar)
        
        return pickerToolbarPadding
    }
    
    private func buildBarItems() -> [UIBarButtonItem] {
        var barItems: [UIBarButtonItem] = []
        
        let labelCancel = UILabel()
        labelCancel.text = "Cancel"
        let titleCancel = UIBarButtonItem(
            title: labelCancel.text,
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(SelectionCell.cancelPickerSelectionButtonClicked(_:)))
        barItems.append(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: self,
            action: nil)
        barItems.append(flexSpace)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
                                      target: self,
                                      action: #selector(SelectionCell.doneClicked(_:)))
        barItems.append(doneBtn)
        
        return barItems
    }
    
    func cancelPickerSelectionButtonClicked(sender: UIBarButtonItem) {
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.mainScreen().bounds.size.height,
                width: UIScreen.mainScreen().bounds.size.width,
                height: 260.0
            )
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func doneClicked(sender: UIBarButtonItem) {
        let myRow = picker.selectedRowInComponent(0)
        self.detailTextLabel?.text = pickerData[myRow]
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.mainScreen().bounds.size.height,
                width: UIScreen.mainScreen().bounds.size.width,
                height: 260.0
            )
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView {
                        view.removeFromSuperview()
                    }
                }
        })
        
        self.onChange(pickerData[myRow])
    }
    
}
