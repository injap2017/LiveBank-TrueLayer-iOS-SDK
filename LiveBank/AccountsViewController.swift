//
//  AccountsViewController.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/17/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var accounts: [Account]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // try to retrieve accounts
        TrueLayerClient.getAccounts() { accounts in
            self.accounts = accounts
            
            // refresh table view
            self.tableView.reloadData()
        }
    }
    
    func initModel() {

    }
    
    func initView() {
        
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accounts = self.accounts {
            return accounts.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell

        // Configure the cell...
        let account = self.accounts?[indexPath.row]
        cell.install(account)

        return cell
    }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // remove the prev account and archive new that one
        LiveBankStore.store()!.removeObject(forKey: LiveBankString.ACCOUNT_STORE_KEY)
        let account = self.accounts?[indexPath.row]; account?.archive(LiveBankString.ACCOUNT_STORE_KEY, into: LiveBankStore.store()!)
        
        self.dismiss(animated: true) { 
            
        }
    }
    
}
