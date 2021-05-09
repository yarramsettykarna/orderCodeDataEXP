//
//  OrderTableViewCell.swift
//  OrderManagement
//
//  Created by karna yarramsetty on 09/05/21.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var OrderNumber: UILabel!
    @IBOutlet weak var OrderDate: UILabel!
    @IBOutlet weak var CustomerName: UILabel!
    @IBOutlet weak var CustomerAddress: UILabel!
    @IBOutlet weak var CustomerPhone: UILabel!
    @IBOutlet weak var OrderTotal: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
