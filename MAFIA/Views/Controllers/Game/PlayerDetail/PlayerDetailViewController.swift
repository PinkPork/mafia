//
//  PlayerDetailViewController.swift
//  MAFIA
//
//  Created by Hugo Bernal on Jan/15/18.
//  Copyright © 2018 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    
    // MARK: - Vars & Lets
    
    weak var player: Player!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleImageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setData(player: player)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Methods
    
    private func setData(player: Player) {
        self.nameLabel.text = player.name
        self.roleImageView.image = UIImage(named: "\(player.role.imageDescription)")
        self.roleLabel.text = player.role.roleDescription
    }

}
