//
//  ChartRoomViewCViewController.swift
//  ChartDemo
//
//  Created by 三斗 on 5/9/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class ChartRoomViewCViewController: UIViewController {
  
  var messageList = [[String:AnyObject]]()
  var nickname = String()
  let notificationCenter = NSNotificationCenter.defaultCenter()
  
  @IBOutlet weak var keyBoard: UIView!{
    didSet{
      keyBoard.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
  }
  @IBOutlet weak var textViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var sendMessageTextField: UITextView!{
    didSet{
      sendMessageTextField.returnKeyType = .Send
      sendMessageTextField.layer.masksToBounds = true
      sendMessageTextField.layer.cornerRadius = 8
      sendMessageTextField.layoutManager.allowsNonContiguousLayout = false
    }
  }
  @IBOutlet weak var inputButtomLayout: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    notificationCenter.addObserver(self, selector: #selector(ChartRoomViewCViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(ChartRoomViewCViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    configureTableView()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    SocketIOManager.sharedInstance.getChartMessage { (messageInfo) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.messageList.append(messageInfo)
        self.tableView.reloadData()
      })
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func configureTableView(){
    tableView.separatorStyle = .None
    tableView.estimatedRowHeight = 30
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
  }
  
  func keyboardDidShow(notifaction:NSNotification){
    if let userInfo = notifaction.userInfo{
      print(userInfo[UIKeyboardFrameBeginUserInfoKey])
      if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue(){
        inputButtomLayout.constant = -keyboardFrame.size.height
        view.layoutIfNeeded()
      }
    }
  }
  
  func keyboardDidHide(notifaction:NSNotification){
    inputButtomLayout.constant = 0
    view.layoutIfNeeded()
  }
  
  func sendMessage(){
    SocketIOManager.sharedInstance.sendMessage(sendMessageTextField.text, nickname: nickname)
    sendMessageTextField.text = ""
  }
}

extension ChartRoomViewCViewController:UITextViewDelegate{
  
  //MARK: - TODO 还没修改textview自适应问题
  
  func textViewDidChange(textView: UITextView) {
//    let contentSize = sendMessageTextField.sizeThatFits(sendMessageTextField.bounds.size)
//    var frame = sendMessageTextField.frame
//    print(contentSize.height)
//    print(contentSize.height - frame.size.height)
//    //sendMessageTextField.frame.origin.y += frame.size.height - contentSize.height
//    keyBoard.frame.origin.y -= rame.size.height - contentSize.height
//    frame.size.height = contentSize.height
//    print(frame.size.height)
//    sendMessageTextField.frame = frame
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n"{
      if sendMessageTextField.text.characters.count > 0 {
        let contentSize = sendMessageTextField.sizeThatFits(CGSizeMake(sendMessageTextField.frame.size.width, CGFloat(MAXFLOAT)))
        print(contentSize)
        textViewConstraint.constant = contentSize.height
        sendMessage()
      }
    }
    return true
  }
}

extension ChartRoomViewCViewController:UITableViewDelegate,UITableViewDataSource{
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messageList.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! ChartRoomTableViewCell
    cell.backgroundColor = UIColor.groupTableViewBackgroundColor()
    cell.messageLabel.text = messageList[indexPath.row]["message"] as? String
    let userNickname = messageList[indexPath.row]["nickname"] as? String
    cell.nicknameLabel.text = userNickname
    cell.nicknameLabel.textAlignment = (nickname == userNickname) ? .Right : .Left
    return cell
  }
}