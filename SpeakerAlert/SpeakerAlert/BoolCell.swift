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
    
    func cell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "OnOffCell", for: indexPath)
        if let cell = c as? OnOffCell {
            cell.titleLabel?.text = self.title
            cell.valueSwitch?.isOn = self.value
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
    @IBAction func valueChanged(_ sender: AnyObject) {
        if let sendSwitch: UISwitch = sender as? UISwitch {
            onChange(sendSwitch.isOn)
        }
    }
    
}
