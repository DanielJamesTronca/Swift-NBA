//
//  PlayerDetailViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import UIKit

class PlayerDetailViewController: UIViewController {
    
    /// Main UIView (with custom rounded corners)
    @IBOutlet var mainView: UIView!
    /// Player image view (fake for the time being)
    @IBOutlet weak var playerImageView: UIImageView!
    /// Player name label
    @IBOutlet weak var playerName: UILabel!
    /// Player team label
    @IBOutlet weak var playerTeam: UILabel!
    /// Player position label
    @IBOutlet weak var playerPosition: UILabel!
    /// XMark button to help close view controller
    @IBOutlet weak var xmarkButton: UIButton!
    /// Fake action button
    @IBOutlet weak var fakeActionButton: UIButton!
    /// Images information outlet collection
    @IBOutlet var imagesInformation: [UIImageView]!
    
    // Player data from previous view
    var playerData: PlayerCoreDataClass? {
        didSet {
            guard playerData != nil else {
                return
            }
        }
    }
    
    // Private var to handle fake action status
    private var isFakeActionTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Configure view once outlets are loaded!
        self.configureView()
    }
    
    private func configureView() {
        guard let playerData = playerData else { return }
        playerName.text = playerData.completeName
        playerTeam.text = playerData.teamFullName
        if let position = playerData.position, !position.isEmpty {
            playerPosition.text = position
        } else {
            playerPosition.text = "Pos: none"
        }
    }
    
    @objc
    private func labelDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func bookmarkTapped(sender: UIButton!) {
        // Change fake action button color since we have no api to call
        self.isFakeActionTapped.toggle()
        self.fakeActionButton.backgroundColor = isFakeActionTapped ? UIColor.orange : UIColor.lightGray
        self.fakeActionButton.tintColor = isFakeActionTapped ? UIColor.white : UIColor.black
    }
    
    private func setupUI() {
        // Main view configuration
        self.mainView.backgroundColor = UIColor.nbaDark
        self.mainView.layer.cornerRadius = MarginManager.smallMargin
        self.mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Player image configuration
        let playerImage: UIImage = UIImage(systemName: "person.fill")!
        self.playerImageView.image = playerImage
        self.playerImageView.tintColor = UIColor.nbaTextColor
        
        // Fake action button configuration
        self.fakeActionButton.setTitle("save_button_title".localized, for: .normal)
        self.fakeActionButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.fakeActionButton.backgroundColor = UIColor.lightGray
        self.fakeActionButton.layer.cornerRadius = MarginManager.smallMargin
        self.fakeActionButton.tintColor = UIColor.black
        self.fakeActionButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)

        // Xmark button configuration
        self.xmarkButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.xmarkButton.titleLabel?.isHidden = true
        self.xmarkButton.addTarget(self, action: #selector(labelDidTap), for: UIControl.Event.touchUpInside)
        self.xmarkButton.tintColor = UIColor.nbaTextColor?.withAlphaComponent(0.75)
        self.xmarkButton.contentVerticalAlignment = .fill
        self.xmarkButton.contentHorizontalAlignment = .fill
        
        // Player name setup
        self.playerName.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.playerName.textColor = UIColor.nbaTextColor
        
        // Player name setup
        self.playerTeam.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.playerTeam.textColor = UIColor.nbaTextColor
        
        // Player name setup
        self.playerPosition.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.playerPosition.textColor = UIColor.nbaTextColor
        
        // Array of images for cell information
        let imagesName: [String] = [
            "person.crop.square.fill",
            "flag.fill",
            "pin.fill"
        ]
        
        // Set images in Outlet collection
        for (imageInformation, imageName) in zip(imagesInformation, imagesName) {
            let image: UIImage = UIImage(systemName: imageName)!
            imageInformation.image = image
            imageInformation.tintColor = UIColor.nbaTextColor?.withAlphaComponent(0.5)
        }
    }
}
