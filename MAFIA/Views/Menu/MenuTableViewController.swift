//
//  MenuTableViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/22/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

@IBDesignable class MenuTableViewController: UITableViewController {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var firstColor = UIColor(red: 0.149, green: 0.106, blue: 0.412, alpha: 1)
    @IBInspectable var secondColor = UIColor(red: 0.659, green: 0.259, blue: 0.733, alpha: 1)
    @IBInspectable var cornerCOlor = UIColor(red: 0.396, green:0.192, blue:0.561, alpha:1)
    @IBInspectable @IBOutlet weak var imageProfileImage: UIImageView!
    
    @IBInspectable @IBOutlet weak var lblName: UILabel!
    @IBInspectable @IBOutlet weak var lblLastName: UILabel!
    
    static var currentView: UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSideMenuSwipeBegin), name: Notification.Name(rawValue: SideMenu.kSideMenuNotificationSwipeBegin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSideMenuSwipeEnded), name: Notification.Name(rawValue: SideMenu.kSideMenuNotificationSwipeEnd), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSideMenuReopened), name: Notification.Name(rawValue: SideMenu.kSideMenuNotificationReopen), object: nil)
        
        self.tableView.register(UINib.init(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
    }
    
    @objc func didSideMenuSwipeBegin(notification: NSNotification) {
        self.tableView.isScrollEnabled = false
    }
    
    @objc func didSideMenuSwipeEnded(notification: NSNotification) {
        self.tableView.isScrollEnabled = true
    }
    
    @objc func didSideMenuReopened(notification: NSNotification) {
        self.tableView.isScrollEnabled = true
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientLayer.colors = [
            firstColor.cgColor as CGColor,
            secondColor.cgColor as CGColor
        ]
        
        let backgroundView = UIView(frame: self.tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        
        self.view.insertSubview(backgroundView, at: 0)
        
//        if let usr = User.sharedInstance{
//            self.lblName.text = usr.name?.stringByReplacingOccurrencesOfString(" ", withString: "\n")
//            if let image = usr.urlImage{
//                if let url = NSURL(string: image) {
//                    if let data = NSData(contentsOfURL: url) {
//                        self.imageProfileImage.image = UIImage(data: data)
//                    }
//                }
//            } // TODO ELSE sets a default image
//        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Segues.Menu.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        
        let imageName = Segues.Menu[indexPath.row][1] + "off"
        
        cell.titleLabel.text = Segues.Menu[indexPath.row][0]
        cell.icon.image = UIImage(named: imageName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let id = "menu" + Segues.Menu[indexPath.row][2]
        self.performSegue(withIdentifier: id, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MenuTableViewController.currentView = segue.destination
    }
}
