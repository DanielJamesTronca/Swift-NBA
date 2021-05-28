//
//  PlayerDetailViewController.swift
//  NBA-app
//
//  Created by Daniel James Tronca on 28/05/21.
//

import Foundation
import UIKit

class PlayerDetailViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerTeam: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var xmarkButton: UIButton!
    @IBOutlet weak var fakeActionButton: UIButton!
    
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
            playerPosition.text = "None"
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
        self.fakeActionButton.setTitle("Bookmark", for: .normal)
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
    }
}
