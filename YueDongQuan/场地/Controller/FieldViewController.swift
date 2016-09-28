//
//  FieldViewController.swift
//  悦动圈
//
//  Created by 黄方果 on 16/9/12.
//  Copyright © 2016年 黄方果. All rights reserved.
//

import UIKit
import SnapKit

class FieldViewController: MainViewController ,BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource{
    var locationService : BMKLocationService?
    var scroViewContent : UIScrollView!
    var fieldTable = UITableView()
    var weatherView = UIView()
    
    var _mapView: BMKMapView!
    
    var zoomCount : Float = 14
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        
        
        
        
        
        
        
        
        locationService = BMKLocationService()
        locationService?.allowsBackgroundLocationUpdates = true
        locationService?.delegate = self
        locationService?.distanceFilter = kCLDistanceFilterNone
        locationService?.desiredAccuracy  = kCLLocationAccuracyBest
        locationService?.startUserLocationService()
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*2/3))
        
        _mapView.userLocationVisible
        _mapView?.showsUserLocation = false;//显示定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone
        _mapView?.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0)
        _mapView?.showMapScaleBar = true
        _mapView.zoomLevel = zoomCount
        _mapView?.mapScaleBarPosition = CGPointMake(_mapView.frame.width - 60, _mapView.frame.height - 20)
        let param = BMKLocationViewDisplayParam()
        param.accuracyCircleStrokeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        param.accuracyCircleFillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.3)
        _mapView.updateLocationViewWithParam(param)
        
        
        let addAndReduceView = UIView(frame: CGRect(x: CGRectGetMaxX(_mapView.frame) - 40, y: CGRectGetMaxY(_mapView.frame) - 80, width: 25, height: 51))
        _mapView.addSubview(addAndReduceView)
        
        let reduceBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        reduceBtn.backgroundColor = UIColor.blueColor()
        reduceBtn.addTarget(self, action: #selector(reduceBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        addAndReduceView.addSubview(reduceBtn)
        
        let addBtn = UIButton(frame: CGRect(x: 0, y: 26, width: 25, height: 25))
        addBtn.backgroundColor = UIColor.brownColor()
        addBtn.addTarget(self, action: #selector(addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        addAndReduceView.addSubview(addBtn)
        
        
        
        
        
        
        
        
        fieldTable = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49 - 64), style: UITableViewStyle.Grouped)
        self.view.addSubview(fieldTable)
        fieldTable.tableHeaderView = _mapView
        
        fieldTable.registerClass(FieldCell.self, forCellReuseIdentifier: "FieldCell")
        fieldTable.delegate = self
        fieldTable.dataSource = self
        
        weatherView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 30))
        weatherView.backgroundColor = UIColor ( red: 0.7802, green: 0.7584, blue: 0.7562, alpha: 0.92 )
        self.view.addSubview(weatherView)
        
        let shutBtn = UIButton(frame: CGRect(x: ScreenWidth - 30, y: 5, width: 20, height: 20))
        shutBtn.setImage(UIImage(named: "photo_delete"), forState: UIControlState.Normal)
        shutBtn.addTarget(self, action: #selector(dismissWeatherView), forControlEvents: UIControlEvents.TouchUpInside)
        weatherView.addSubview(shutBtn)
        
        
    }
    
    func dismissWeatherView(){
        weatherView.removeFromSuperview()
    }
    
    func reduceBtnClick(){
        if zoomCount > 14 {
            zoomCount -= 1
        }else{
            zoomCount = 14
        }
        _mapView.zoomLevel = zoomCount
        
    }
    func addBtnClick(){
        if zoomCount < 20 {
            zoomCount += 1
        }
        _mapView.zoomLevel = zoomCount
    }
    
    
    func setNav(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_lanqiu"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24.0 / 255, green: 90.0 / 255, blue: 172.0 / 255, alpha: 1.0)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 32))
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        searchBtn.setImage(UIImage(named: "ic_search"), forState: UIControlState.Normal)
        rightView.addSubview(searchBtn)
        let addBtn = UIButton(frame: CGRect(x: 33, y: 0, width: 32, height: 32))
        addBtn.setImage(UIImage(named: "ic_search"), forState: UIControlState.Normal)
        rightView.addSubview(addBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
        _mapView?.viewWillAppear()
        _mapView?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView?.viewWillAppear()
        _mapView?.delegate = nil
    }
    func willStartLocatingUser() {
        locationService?.startUserLocationService()
    }
    
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        NSLog("didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude)
        _mapView.updateLocationData(userLocation)
    }
    
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        NSLog("didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude)
        _mapView?.updateLocationData(userLocation)
        _mapView.showsUserLocation = true
        _mapView?.setCenterCoordinate(CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 243/255, alpha: 1.0)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 243/255, alpha: 1.0)
        return footerView
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : FieldCell = tableView.dequeueReusableCellWithIdentifier("FieldCell", forIndexPath: indexPath) as! FieldCell
        cell.index = indexPath
        cell.delegate = self
        return cell
        
    }

    

}


extension FieldViewController : FieldCellDelegate {
    func clickConfirmFieldBtn(indexPath: NSIndexPath) {
        NSLog("点击了预定")
        
        let telNumber = "18798812521"
        
        let alertView = YoYoAlertView(title: "我要订场", message: telNumber, cancelButtonTitle: "取消", sureButtonTitle: "确定")
        
        alertView.show()
        
        alertView.clickIndexClosure { (index) in
            print("点击了第" + "\(index)" + "个按钮")
            
            if index == 2 {
                self.CallTelNumber(telNumber)
            }
            
        }
        
    }
    func clickEditFieldBtn(indexPath: NSIndexPath) {
        NSLog("点击了编辑")
        let vc = EditorFieldViewController()
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        vc.hidesBottomBarWhenPushed = false
//        let nvc1 : UINavigationController = CustomNavigationBar(rootViewController: vc)
//        
//        self.navigationController?.presentViewController(nvc1, animated: true, completion: {
//            
//        })
        
    }
    func clickSiginFieldBtn(indexPath: NSIndexPath) {
        NSLog("点击了签到")
        let signVC = SignRankingCOntroller()
        signVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signVC, animated: true)
        signVC.hidesBottomBarWhenPushed = false
        
    }
    
    
    func clickQianDaoImageTap(indexPath:NSIndexPath){
        let signvc = SignRankBtnController()
        signvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(signvc, animated: true)
        signvc.hidesBottomBarWhenPushed = false
        
    }
    
    
    //拨打电话
    func CallTelNumber(tel:String){
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(tel)")!)
    }
    
    
}






