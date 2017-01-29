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
    
    init(title: String, initialValue: String, options: [String], onChange: @escaping (String) -> ()) {
        self.title = title
        self.initialValue = initialValue
        self.options = options
        self.onChange = onChange
    }
    
    fileprivate var cell: SelectionCell?
    
    func performAction() {
        if let c = cell {
            c.openPicker()
            c.setSelectedValue(initialValue)
        }
    }
    
    func cell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SelectionCell",
            for: indexPath
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
        _ _pickerView: UIPickerView,
        titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func setSelectedValue(_ value: String) {
        for (index, item) in pickerData.enumerated() {
            if item == value {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    func openPicker() {
        let kSCREEN_WIDTH  =    UIScreen.main.bounds.size.width
        let PICKER_HEIGHT = UIScreen.main.bounds.size.height/3
        
        picker.frame = CGRect(x: 0.0, y: 44.0, width: kSCREEN_WIDTH, height: (PICKER_HEIGHT - 44))
        picker.dataSource = self
        picker.delegate = self
        picker.showsSelectionIndicator = true
        picker.backgroundColor = UIColor.white
        
        actionView.addSubview(setupToolbar())
        actionView.addSubview(picker)
        
        if (window) != nil {
            window!.addSubview(actionView)
        } else {
            self.superview?.addSubview(actionView)
        }
        
        self.actionView.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.size.height,
            width: UIScreen.main.bounds.size.width,
            height: PICKER_HEIGHT)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.main.bounds.size.height - PICKER_HEIGHT,
                width: UIScreen.main.bounds.size.width,
                height: PICKER_HEIGHT)
        })
    }
    
    fileprivate func setupToolbar() -> UIView {
        let kSCREEN_WIDTH  =    UIScreen.main.bounds.size.width
        
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
    
    fileprivate func buildBarItems() -> [UIBarButtonItem] {
        var barItems: [UIBarButtonItem] = []
        
        let labelCancel = UILabel()
        labelCancel.text = "Cancel"
        let titleCancel = UIBarButtonItem(
            title: labelCancel.text,
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(SelectionCell.cancelPickerSelectionButtonClicked(_:)))
        barItems.append(titleCancel)
        
        var flexSpace: UIBarButtonItem
        flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
            target: self,
            action: nil)
        barItems.append(flexSpace)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                      target: self,
                                      action: #selector(SelectionCell.doneClicked(_:)))
        barItems.append(doneBtn)
        
        return barItems
    }
    
    func cancelPickerSelectionButtonClicked(_ sender: UIBarButtonItem) {
        let PICKER_HEIGHT = UIScreen.main.bounds.size.height/3
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.main.bounds.size.height,
                width: UIScreen.main.bounds.size.width,
                height: PICKER_HEIGHT
            )
            
            }, completion: { _ in
                for obj: AnyObject in self.actionView.subviews {
                    if let view = obj as? UIView {
                        view.removeFromSuperview()
                    }
                }
        })
    }
    
    func doneClicked(_ sender: UIBarButtonItem) {
        let PICKER_HEIGHT = UIScreen.main.bounds.size.height/3
        
        let myRow = picker.selectedRow(inComponent: 0)
        self.detailTextLabel?.text = pickerData[myRow]
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.actionView.frame = CGRect(
                x: 0,
                y: UIScreen.main.bounds.size.height,
                width: UIScreen.main.bounds.size.width,
                height:  PICKER_HEIGHT
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
