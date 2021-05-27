//
//  LoadingTeamsTableViewCell.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit

class LoadingTeamsTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        // Loading label setup
        self.loadingLabel.text = "generic_loading_title"
        self.loadingLabel.textColor = UIColor.red
        self.loadingLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)

        // Activity indicator setup
        self.activityIndicator.color = UIColor.red
    }
}
