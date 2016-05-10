//
//  UserListViewController.swift
//  ChartDemo
//
//  Created by 三斗 on 5/9/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var exitButton: UIBarButtonItem!
  var userList = [[String:AnyObject]]()
  var nickname:String!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  
  
  @IBAction func exitButton(sender: UIBarButtonItem) {
    if nickname != nil{
      SocketIOManager.sharedInstance.exitToServerWithNickName(nickname) {
        dispatch_async(dispatch_get_main_queue(), {
          self.nickname = nil
          self.userList.removeAll()
          self.tableView.hidden = true
          sender.title = "login"
        })
      }
    }else{
      askForNickname()
    }
  }
  
  
  @IBAction func justChart(sender: UIButton) {
    self.performSegueWithIdentifier("goToChartRoom", sender: nil)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if nickname == nil{
      askForNickname()
      tableView.hidden = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func askForNickname(){
    let alertController = UIAlertController(title: "请输入名字", message: nil, preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler(nil)
    let okAction = UIAlertAction(title: "确定", style: .Default) { (action) in
      let textField = alertController.textFields![0]
      if textField.text?.characters.count == 0{
        self.askForNickname()
      }else{
        self.nickname = textField.text!
        SocketIOManager.sharedInstance.connectToServerWithNickname(self.nickname, handle: { (data) in
          dispatch_async(dispatch_get_main_queue(), {
            if data != nil{
              self.userList = data
              self.tableView.reloadData()
              self.tableView.hidden = false
              self.exitButton.title = "exit"
            }
          })
        })
        
      }
    }
    alertController.addAction(okAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "goToChartRoom"{
      if let cvc = segue.destinationViewController as? ChartRoomViewCViewController{
        cvc.nickname = nickname
        
      }
    }
  }
}

extension UserListViewController:UITableViewDataSource,UITableViewDelegate{
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserListTableViewCell
    cell.nicknameLabel.text = userList[indexPath.row]["nickname"] as? String
    if let status = userList[indexPath.row]["isConnected"] as? Bool{
      cell.statusLabel?.textColor = status ? UIColor.greenColor():UIColor.redColor()
      cell.statusLabel?.text = status ? "online" : "offline"
    }
    return cell
  }
}

