//
//  TeamTableViewCell.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 27/05/21.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet var informationImages: [UIImageView]!
    
    @IBOutlet weak var divisionLabel: UILabel!
    @IBOutlet weak var conferenceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }
    
    public func configure(with data: TeamData) {
        self.teamName.text = data.teamFullName
        self.divisionLabel.text = data.division
        self.conferenceLabel.text = data.conference
        self.cityLabel.text = data.city
    }
    
    // Private func to setup UI, font, size, colors...
    private func setupUI() {
        // Team name setup
        self.teamName.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        self.teamName.textColor = UIColor.nbaTextColor
        
        // Team division setup
        self.divisionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.divisionLabel.textColor = UIColor.nbaTextColor?.withAlphaComponent(0.5)
        
        // Team conference setup
        self.conferenceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.conferenceLabel.textColor = UIColor.nbaTextColor?.withAlphaComponent(0.5)
        
        // Team abbreviation setup
        self.cityLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.cityLabel.textColor = UIColor.nbaTextColor?.withAlphaComponent(0.5)
        
        // Array of images for cell information
        let imagesName: [String] = [
            "rectangle.3.offgrid",
            "paperplane",
            "globe"
        ]
        
        // Set images in Outlet collection
        for (informationImage, imageName) in zip(informationImages, imagesName) {
            let image: UIImage = UIImage(systemName: imageName)!
            informationImage.image = image
            informationImage.tintColor = UIColor.nbaTextColor?.withAlphaComponent(0.5)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
