//
//  ViewController.swift
//  LiveBank
//
//  Created by Edgar Sia on 10/12/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var accessToken: String?
    var account: Account?
    var balance:Balance?
    var updatedTimestamp:Date?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var updatedTimestampLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var youravailableBalanceLabel: UILabel!
    
    var refreshControl:UIRefreshControl?
    
    var timer: Timer?
    
    func startTimer() {
        if let t = self.timer {
            t.invalidate()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if let t = self.timer {
            t.invalidate()
        }
        
        self.timer = nil
    }
    
    @objc func tick() {
        self.refreshView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // if out truelayer then try to login
        if self.accessToken == nil || self.account == nil {
            let navController = self.storyboard!.instantiateViewController(withIdentifier: "truelayer") as! UINavigationController
            self.present(navController, animated: true, completion: {
                
            })
        }
        else {
            // refresh view
            if self.balance != nil && self.updatedTimestamp != nil{
                self.refreshView()
                self.startTimer()
            }
            else {
                // try to get balance info from your bank
                self.update()
            }
        }
    }
    
    func initModel() {
        if let accessToken = TrueLayerClient.currentAccessToken() {
            print(accessToken)
            self.accessToken = accessToken
        }
        
        if LiveBankStore.store()!.isKeyPresent(LiveBankString.ACCOUNT_STORE_KEY) {
            let account = Account(); account.unarchive(LiveBankString.ACCOUNT_STORE_KEY, into: LiveBankStore.store()!)
            self.account = account
            print(account)
        }
        
        if LiveBankStore.store()!.isKeyPresent(LiveBankString.BALANCE_STORE_KEY) {
            let balance = Balance(); balance.unarchive(LiveBankString.BALANCE_STORE_KEY, into: LiveBankStore.store()!)
            self.balance = balance
            print(balance)
            
        }
        
        if LiveBankStore.store()!.isKeyPresent(LiveBankString.UPDATED_TIMESTAMP_STORE_KEY) {
            let updatedTimestamp = Date.unarchive(LiveBankString.UPDATED_TIMESTAMP_STORE_KEY, into: LiveBankStore.store()!)
            self.updatedTimestamp = updatedTimestamp
            print(updatedTimestamp)
            
        }
    }
    
    func initView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        self.scrollView.addSubview(refreshControl!)
    }
    
    @objc func refresh() {
        self.update()
    }
    
    func refreshView() {
        
        self.providerNameLabel.text = ""
        self.accountNameLabel.text = ""
        if let account = self.account {
            self.providerNameLabel.text = account.provider?.displayName
            self.accountNameLabel.text = account.displayName
        }
        
        self.availableBalanceLabel.attributedText = nil
        self.youravailableBalanceLabel.text = ""
        if let balance = self.balance {
            self.availableBalanceLabel.attributedText = Double().attributedCurrency(from: (balance.available)!)
            self.youravailableBalanceLabel.text = "Your Available Balance"
        }
        
        self.updatedTimestampLabel.text = ""
        if let updatedTimestamp = self.updatedTimestamp {
            self.updatedTimestampLabel.text = Date.lastUpdatedFrom(date: updatedTimestamp)
        }

    }
    
    func update() {
        
        TrueLayerClient.getBalance(ofAccount: (self.account?.accountID)!, failure: { error in
            print(error)
            
            // Network error alert
            DispatchQueue.main.async {
                let alert = UIAlertController.init(title: "Error", message: "Network error: Live Bank. caused connection abort", preferredStyle: .alert)
                
                let okay = UIAlertAction.init(title: "OK", style: .default, handler: { action in
                    
                    // End refresh
                    self.refreshControl?.endRefreshing()
                })
                
                alert.addAction(okay)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }) { balance in
            print(balance)
            
            self.balance = balance
            
            LiveBankStore.store()!.removeObject(forKey: LiveBankString.BALANCE_STORE_KEY)
            self.balance?.archive(LiveBankString.BALANCE_STORE_KEY, into: LiveBankStore.store()!)
            
            self.updatedTimestamp = Date()
            
            LiveBankStore.store()!.removeObject(forKey: LiveBankString.UPDATED_TIMESTAMP_STORE_KEY)
            self.updatedTimestamp?.archive(LiveBankString.UPDATED_TIMESTAMP_STORE_KEY, into: LiveBankStore.store()!)
            
            // refresh view
            DispatchQueue.main.async {
                self.refreshView()
                self.refreshControl?.endRefreshing()
                self.startTimer()
            }
        }
    }

    func clean() {
        
        // remove LiveBank session
        self.accessToken = nil
        self.account = nil
        self.balance = nil
        self.updatedTimestamp = nil
        
        LiveBankStore.store()!.removeObject(forKey: LiveBankString.ACCOUNT_STORE_KEY)
        LiveBankStore.store()!.removeObject(forKey: LiveBankString.BALANCE_STORE_KEY)
        LiveBankStore.store()!.removeObject(forKey: LiveBankString.UPDATED_TIMESTAMP_STORE_KEY)
    }
    
    @IBAction func liveBank(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Live Bank.", message: "Which of the following actions should you take?", preferredStyle: .actionSheet)
        
        let logout = UIAlertAction.init(title: "Log Out", style: .default) { action in
            
            // remove TrueLayer SDK session
            TrueLayerClient.logout()
            
            // remove LiveBank session
            self.clean()
            
            // refresh view
            self.refreshView()
            
            // try to log in
            let navController = self.storyboard!.instantiateViewController(withIdentifier: "truelayer") as! UINavigationController
            self.present(navController, animated: true, completion: {
                
            })
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { action in
            
        }
        
        alert.addAction(logout)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

