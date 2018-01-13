//
//  ActionCell.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/8/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit


struct ActionCellDefinition: CellDefinition, CellWithAction {
    var title: String = ""
    var detail: String?
    var hasDisclosure: Bool = false
    var action: () -> () = {}
    
    func performAction() {
        self.action()
    }
    
    func cell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ActionCell",
            for: indexPath
        )
        if let c = cell as? ActionCell {
            c.titleLabel?.text = self.title
            c.detailTextLabel?.isHidden = true
            if self.hasDisclosure {
                c.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else {
                c.accessoryType = UITableViewCellAccessoryType.none
            }
            if let d = self.detail {
                c.detailTextLabel?.isHidden = false
                c.detailTextLabel?.text = d
            }
        }
        return cell
    }
}

class ActionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
}
