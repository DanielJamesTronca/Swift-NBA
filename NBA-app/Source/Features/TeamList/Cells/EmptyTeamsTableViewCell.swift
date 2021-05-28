//
//  EmptyTeamsTableViewCell.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit

class EmptyTeamsTableViewCell: UITableViewCell {

    // Empty image
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
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
        // No data label setup
        self.emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.emptyLabel.textColor = UIColor.blue.withAlphaComponent(0.5)
        self.emptyLabel.text = "no_data_title_label".localized
        
        // No data image setup
        let noDataImage: UIImage = UIImage(systemName: "doc.append.fill")!
        self.emptyImage.image = noDataImage
        self.emptyImage.tintColor = UIColor.lightGray
    }
}
