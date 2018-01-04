//
//  MenuViewController.swift
//  MAFIA
//
//  Created by Santiago Carmona Gonzalez on 12/27/17.
//  Copyright © 2017 Santiago Carmona Gonzalez. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func performSegue(withIdentifier identifier: String)
}

class MenuViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -  Vars & Constants
    
    var menuOptions: [MenuOptions] = []
    var presenter: MenuPresenter!
    weak var delegate: MenuViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    
    private func setupView() {
        presenter = MenuPresenter(view: self)
        presenter.displayOptions()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - MenuView protocol conformance

extension MenuViewController: MenuView {
    func setMenu(options: [MenuOptions]) {
        menuOptions = options
        tableView.reloadData()
    }
}


// MARK: - TableView DataSource

extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = menuOptions[indexPath.row].title
        return cell
    }
}

// MARK: - TableView Delegate

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = menuOptions[indexPath.row]
        let segue = "Segue\(selectedOption)"
        try! SideMenu.sharedInstance?.animateMenu()
        delegate?.performSegue(withIdentifier: segue)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


