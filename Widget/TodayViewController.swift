//
//  TodayViewController.swift
//  Widget
//
//  Created by Edgar Sia on 10/18/17.
//  Copyright © 2017 TrueLayer. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var accessToken: String?
    var account: Account?
    var balance:Balance?
    var updatedTimestamp:Date?
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var youravailableBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        initModel()
        initView()
        
        print("update")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        print("none")
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func initModel() {
        
        TrueLayerClient.reload()
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
        // if out truelayer then try to login
        if self.accessToken == nil || self.account == nil {
            self.availableBalanceLabel.isHidden = true
            self.displayNameLabel.isHidden = true
            self.youravailableBalanceLabel.isHidden = true
            self.loginButton.isHidden = false
        }
        else {
            // refresh view
            if self.balance != nil && self.updatedTimestamp != nil{
                self.availableBalanceLabel.isHidden = false
                self.displayNameLabel.isHidden = false
                self.youravailableBalanceLabel.isHidden = false
                self.loginButton.isHidden = true
                
                self.refreshView()
                
                self.update()
            }
            else {
                // try to get balance info from your bank
                self.availableBalanceLabel.isHidden = false
                self.displayNameLabel.isHidden = false
                self.youravailableBalanceLabel.isHidden = false
                self.loginButton.isHidden = true
                
                self.update()
            }
        }
    }
    
    func refreshView() {
        self.availableBalanceLabel.attributedText = Double().attributedCurrency(from: (self.balance?.available)!)
        self.displayNameLabel.text = (self.account?.provider?.displayName)! + " " + (self.account?.displayName)!
        self.youravailableBalanceLabel.text = "Available Balance"
    }
    
    func refresh() {
        self.update()
    }
    
    func update() {
        TrueLayerClient.getBalance(ofAccount: (self.account?.accountID)!) { balance in
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
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let uri = URL(string: "livebank://todayextension")
        self.extensionContext?.open(uri!, completionHandler: { (success) in
            
        })
    }
}
