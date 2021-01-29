//
//  VehicleCell.swift
//  FreeNowTask
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit

class VehicleCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(to viewModel: VehicleViewModel) {
        stateLabel.text = viewModel.state
        typeLabel.text = viewModel.type
        idLabel.text = "\(viewModel.id)"
    }
}
