//
//  SignRankBtnController.swift
//  YueDongQuan
//
//  Created by HKF on 16/9/20.
//  Copyright © 2016年 黄方果. All rights reserved.
//

import UIKit
import SnapKit

class SignRankBtnController: UIViewController,SignHeaderViewDelegate {
    
    
    
    
    var timeStr : Double = 0
    var timer : XTimer!
    var leftView : UIView!
    var imgView : UIImageView!
    
    
    
    private var signTableView : UITableView!
    let SignHeaderview = SignHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth - 50))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = .None
        
        setNav()
        setUI()
        
        
        timer = XTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(backgroundThreadFire), userInfo: nil, repeats: true)
        
        timer.stop()
        
    }
    
    func clickSignBtn(sender: UIButton) {
        NSLog("sender:\(sender.selected)")
        
        if sender.selected == true
        {
            timer.reStart()
            imgView.image = UIImage(named: "")
            imgView.userInteractionEnabled = false
            
        }else{
            imgView.image = UIImage(named: "CDEditBack.jpg")
            imgView.userInteractionEnabled = true
            timer.stop()
            timer.invalidate()
        }
        
        
        
        
    }
    
    
    
    func backgroundThreadFire(){
        
        timeStr += 1/10
        
        SignHeaderview.toDayTime = String(format: "%0.2f",timeStr)

        SignHeaderview.cicleView.add = 0.01
    }
    
    deinit{
        timer.invalidate()
    }
    
    
    
    func setNav(){
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        imgView = UIImageView(frame:leftView.frame)
        imgView.image = UIImage(named: "CDEditBack.jpg")
        imgView.contentMode = .Center
        imgView.userInteractionEnabled = true
        leftView.addSubview(imgView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        
        imgView.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)
        
        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.451, green: 0.6824, blue: 0.3098, alpha: 1.0 )
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: .Default)
                self.navigationController?.navigationBar.shadowImage = nil
    }
    func dismissVC(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setUI(){
        signTableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49), style: UITableViewStyle.Grouped)
        
        SignHeaderview.delegate = self
        signTableView.tableHeaderView = SignHeaderview
        signTableView.tableHeaderView?.reloadInputViews()
        signTableView.delegate = self
        signTableView.dataSource = self
        signTableView.separatorStyle = .None
        signTableView.registerClass(SignSportsCell.self, forCellReuseIdentifier: "SignSportsCell")
        signTableView.registerClass(SignPersonCell.self, forCellReuseIdentifier: "SignPersonCell")
        
        self.view.addSubview(signTableView)
    }
    
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {


    }
    override func viewWillDisappear(animated: Bool) {
//        timer.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    

}

extension SignRankBtnController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 10
        }
        
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let headerView = SignCellForHeader()
            headerView.titleText.text = "场地圈子"
            return headerView
        }else{
            let headerView = SignCellForHeader()
            headerView.titleText.text = "今日到场"
            return headerView
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell : SignSportsCell = tableView.dequeueReusableCellWithIdentifier("SignSportsCell", forIndexPath: indexPath) as! SignSportsCell
            
            return cell
            
        }else{
            let cell : SignPersonCell = tableView.dequeueReusableCellWithIdentifier("SignPersonCell", forIndexPath: indexPath) as! SignPersonCell
            
            return cell
        }
        
        
    }
    
}






