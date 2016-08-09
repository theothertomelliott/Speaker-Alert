//
//  BoolCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/8/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

struct BoolCellDefinition: CellDefinition {
    var title: String = ""
    var value: Bool = false
    var onChange: (Bool) -> () = {_ in}
    
    func cell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCellWithIdentifier("OnOffCell", forIndexPath: indexPath)
        if let cell = c as? OnOffCell {
            cell.titleLabel?.text = self.title
            cell.valueSwitch?.on = self.value
            cell.onChange = self.onChange
            return cell
        }
        return c
    }
}

class OnOffCell: UITableViewCell {
    
    var onChange: (Bool) -> () = {_ in }
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var valueSwitch: UISwitch?
    @IBAction func valueChanged(sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            onChange(sendSwitch.on)
        }
    }
    
}
