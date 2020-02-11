//
//  OpenTokViewController.swift
//  Doutor Ao Vivo Demo
//
//  Created by Prime IT Solutions on 16/01/20.
//  Copyright © 2020 Prime IT Solutions. All rights reserved.
//

import UIKit
import OpenTok

// Replace with your OpenTok API key
var kApiKey = "46302052"

public class DavViewController: UIViewController, OTSessionDelegate, OTPublisherDelegate, OTSubscriberDelegate {
    
    //variáveis gerais
    var alertMsg:String = ""
    var timer = Timer()
    public var DAV_URL_ACCESS:String=""
    var X_API_ID:String=Bundle.main.bundleIdentifier!
    var accessRoomKey:String=""
    var appointmentId:String=""
    var authRoomParticipant:String=""
    var roomParticipants:Array<Any>?
    var kSessionId:String = ""
    var kToken:String = ""
    var publisherRole:String = ""
    var sessionInit:String?
    var statusAppointment:String?
    let screenBounds = UIScreen.main.bounds
    
    //cores personalizadas
    public var davColorPrimary:UIColor? //#1976d2
    public var davBackgroundActionsRoom:UIColor? //#6D7BCCFB
    public var davBackgroundVideoHeaderParticipant:UIColor? //#6D7BCCFB
    public var davTextColorVideoHeaderParticipant:UIColor? //#FFFFFF
    public var davTextColorButtonActionsRoom:UIColor? //#FFFFFF
    public var davBackgroundButtonEndCallActionsRoom:UIColor? //#FF050A
    public var davBackgroundButtonActionsRoom:UIColor? //#1976d2
    public var davBackgroundBallonOtherColor:UIColor? //#7bccfb
    public var davTextColorBallonOther:UIColor? //#ffffff
    public var davBackgroundBallonMineColor:UIColor? //#1976d2
    public var davTextColorballonMine:UIColor? //#ffffff
    
    //domínios
    var domain:String = ""
    let domainDev:String = "https://mobile.dev.doutoraovivo.com.br"
    let domainHom:String = "https://mobile.hom.doutoraovivo.com.br"
    let domainProd:String = "https://mobile.doutoraovivo.com.br"
    
    //criação da session
    var session: OTSession?
    var publisher: OTPublisher?
    var subscriber: OTSubscriber?
    var subscriber2: OTSubscriber?
    var subscriber3: OTSubscriber?
    var publisherView: UIView?
    var subscriberView: UIView?
    var subscriberView2: UIView?
    var subscriberView3: UIView?
    var navBar: UIToolbar?
    var tbButtons: UIToolbar?
    var publisherToolBar: UIToolbar?
    var subscriberToolBar: UIToolbar?
    var subscriberToolBar2: UIToolbar?
    var subscriberToolBar3: UIToolbar?
    var publisherName:String=""
    var subscriberName:String=""
    var subscriberName2:String=""
    var subscriberName3:String=""
    
    //variáveis de configuração
    public var showButtonVideo:Bool?
    public var showButtonMicSub:Bool?
    public var showButtonMicSub2:Bool?
    public var showButtonMicSub3:Bool?
    public var showButtonRecord:Bool?
    public var showButtonShare:Bool?
    public var showButtonPrint:Bool?
    public var showButtonArchive:Bool?
    public var showButtonClose:Bool?
    public var showButtonMsg:Bool?
    
    //objetos criados e  runtime
    var vSpinner : UIView?
    var items = [UIBarButtonItem]()
    var itemsPub = [UIBarButtonItem]()
    var itemsSub = [UIBarButtonItem]()
    var itemsSub2 = [UIBarButtonItem]()
    var itemsSub3 = [UIBarButtonItem]()
    var timerLabel:UIBarButtonItem?
    var buttonMic:UIBarButtonItem?
    var buttonCam:UIBarButtonItem?
    var buttonMicSub:UIBarButtonItem?
    var buttonMicSub2:UIBarButtonItem?
    var buttonMicSub3:UIBarButtonItem?
    var buttonShare:UIBarButtonItem?
    var buttonBack:UIBarButtonItem?
    var buttonClose:UIBarButtonItem?
    var buttonArchive:UIBarButtonItem?
    var buttonMsg:UIBarButtonItem?
    var buttonRecord:UIBarButtonItem?
    var buttonPrint:UIBarButtonItem?
    var tapPubView:UITapGestureRecognizer?
    var tapSubView:UITapGestureRecognizer?
    var tapSub2View:UITapGestureRecognizer?
    var tapSub3View:UITapGestureRecognizer?
    
    //posições das views
    var pubViewPos:Int?
    var subViewPos:Int?
    var subViewPos2:Int?
    var subViewPos3:Int?
    //0: main
    //1: right
    //2: middle
    //3: left
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftItemsSupplementBackButton = true
        self.view.backgroundColor = davColorPrimary
        //Navitem
        //toolbar de comandos
        tbButtons = UIToolbar()
        tbButtons!.barStyle = UIBarStyle.default
        tbButtons!.isTranslucent = true
        tbButtons!.barTintColor = davBackgroundActionsRoom
        view.addSubview(tbButtons!)
        tbButtons!.tintColor = davTextColorButtonActionsRoom
        tbButtons!.translatesAutoresizingMaskIntoConstraints = false
        tbButtons!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tbButtons!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tbButtons!.bottomAnchor.constraint(equalTo:  bottomLayoutGuide.topAnchor).isActive = true
        buttonBack = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(closeView))
        items.append(buttonBack!)
        tbButtons!.setItems(items, animated: true)
        //connectToAnOpenTokSession()
        if (X_API_ID.count == 0) { X_API_ID = "0" } //excluir esta linha após a implementação do x-api-id
        if DAV_URL_ACCESS.contains(".dev.") {
            domain = domainDev
        } else if DAV_URL_ACCESS.contains(".hom.") {
            domain = domainHom
        } else {
            domain = domainProd
        }
        iniciaSala()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            self.closeView()
        }
    }
    
    @objc func closeView(){
        if (self.session != nil){
            var error: OTError?
            self.session!.disconnect(&error)
        }
        self.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        resizePublisherView(size)
        resizeSubscriberView(size)
        resizeSubscriberView2(size)
        resizeSubscriberView3(size)
    }
    
    @IBAction func showAlert(_ sender: Any){
        let alertController = UIAlertController(title: "Alert", message: alertMsg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerHeight = Int(onView.bounds.height) - 44
        let spinnerView = UIView.init(frame: CGRect(x: 0, y: 0, width: Int(onView.bounds.width), height: spinnerHeight))
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func iniciaSala() {
        if (X_API_ID.count > 0){
            if (DAV_URL_ACCESS.count > 0) {
                let urlElem = DAV_URL_ACCESS.components(separatedBy: "/") as Array<Any>
                self.accessRoomKey = urlElem.last as! String
                if (accessRoomKey.count > 0) {
                    self.accessRoom()
                } else {
                    alertMsg = "URL inválida"
                    showAlert(self)
                    self.closeView()
                }
            } else {
                alertMsg = "Informe o endereço do Access Room"
                showAlert(self)
                self.closeView()
            }
        } else {
            alertMsg = "Informe a API Key"
            showAlert(self)
            self.closeView()
        }
    }
    
    func accessRoom() {
        self.showSpinner(onView: self.view)
        var request = URLRequest(url: URL(string: domain + "/appointment/accessroom?access=" + accessRoomKey)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                if (json["appointmentId"] != nil) {
                    self.appointmentId = json["appointmentId"] as! String
                    self.authRoomParticipant = json["x-auth-room-participant"] as! String
                    if (self.appointmentId.count > 0 && self.authRoomParticipant.count > 0) {
                        self.checkIn()
                    } else {
                        self.removeSpinner()
                        self.alertMsg="Erro ao carregar dados da consulta"
                        self.showAlert(self)
                        self.closeView()
                    }
                } else {
                    if (json["code"] != nil && json["message"] != nil) {
                        let errorCode = json["code"] as! NSNumber
                        let errorMsg:String = json["message"] as! String
                        self.alertMsg="Erro " + errorCode.stringValue + ": " + errorMsg
                    } else {
                        self.alertMsg="Erro ao carregar dados da consulta"
                    }
                    self.removeSpinner()
                    self.showAlert(self)
                    self.closeView()
                }
            } catch {
                self.removeSpinner()
                self.alertMsg="Erro ao carregar dados da consulta"
                self.showAlert(self)
                self.closeView()
            }
        })
        task.resume()
    }
    
    func checkIn() {
        var request = URLRequest(url: URL(string: domain + "/appointment/checkin?id=" + appointmentId)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authRoomParticipant, forHTTPHeaderField: "x-auth-room-participant")
        request.addValue(X_API_ID, forHTTPHeaderField: "x-api-id")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                if (json["participants"] != nil && json["session"] != nil) {
                    self.roomParticipants = json["participants"] as? Array<Any>
                    self.kSessionId = json["session"] as! String
                    self.statusAppointment = json["status_appointment"] as? String
                    self.sessionInit = json["date_start_attendance"] as? String
                    for participant in self.roomParticipants! {
                        let participantObj  = participant as? Dictionary<String, AnyObject>
                        if (participantObj!["token"] != nil) {
                            self.kToken = participantObj!["token"] as! String
                            self.publisherName = participantObj!["name"] as! String
                            let roleObj = participantObj!["role"] as? Dictionary<String, AnyObject>
                            if (roleObj!["code"] != nil) {
                                self.publisherRole = roleObj!["code"] as! String
                            }
                        }
                    }
                    if (self.kToken.count > 0) {
                        self.connectToAnOpenTokSession()
                    } else {
                        self.removeSpinner()
                        self.alertMsg="Erro ao autenticar consulta. Token inválido"
                        self.showAlert(self)
                        self.closeView()
                    }
                } else {
                    if (json["code"] != nil && json["message"] != nil) {
                        let errorCode = json["code"] as! NSNumber
                        let errorMsg:String = json["message"] as! String
                        self.alertMsg="Erro " + errorCode.stringValue + ": " + errorMsg
                    } else {
                        self.alertMsg="Erro ao obter resposta do servidor"
                    }
                    self.removeSpinner()
                    self.showAlert(self)
                    self.closeView()
                }
            } catch {
                self.removeSpinner()
                self.alertMsg="Erro ao carregar dados da consulta"
                self.showAlert(self)
                self.closeView()
            }
        })
        task.resume()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:(#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var dateInit = Date()
        if (sessionInit != nil ) {
            dateInit = Dateformatter.date(from: sessionInit!)!
            dateInit = dateInit.addingTimeInterval(-3600)
        } else {
            sessionInit! = Dateformatter.string(from: dateInit)
        }
        let calendar = Calendar.current
        let dateDiff = calendar.dateComponents([Calendar.Component.second], from: dateInit, to: Date())
        let diffTotal = dateDiff.second!
        let hours = Int(diffTotal) / 3600
        let minutes = Int(diffTotal) / 60 % 60
        let seconds = Int(diffTotal) % 60
        if (hours > 0) {
            timerLabel?.title = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            timerLabel?.title = String(format:"%02i:%02i", minutes, seconds)
        }
    }
    
    func addToolBarSpace() {
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
    }
    
    func addTimerLabel() {
        let timerValue:String = "00:00"
        timerLabel = UIBarButtonItem(title: timerValue, style: .plain, target: nil, action: nil)
        items.append(timerLabel!)
    }
    
    func addMicButton() {
        //botão Microfone
        buttonMic = UIBarButtonItem(image: UIImage(named: "mic-on")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleMic))
        items.append(buttonMic!)
    }
    
    func addVideoButton() {
        //botão Video
        buttonCam = UIBarButtonItem(image: UIImage(named: "video-on")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleCam))
        items.append(buttonCam!)
    }
    
    func addRecordButton() {
        buttonRecord = UIBarButtonItem(image: UIImage(named: "record")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleRecord))
        items.append(buttonRecord!)
    }
    
    func addPrintButton() {
        buttonPrint = UIBarButtonItem(image: UIImage(named: "print")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(togglePrint))
        items.append(buttonPrint!)
    }
    
    func addShareButton() {
        buttonShare = UIBarButtonItem(image: UIImage(named: "share")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleShare))
        items.append(buttonShare!)
    }
    
    func addArchiveButton() {
        buttonArchive = UIBarButtonItem(image: UIImage(named: "archive")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleArchive))
        items.append(buttonArchive!)
    }
    
    func addCloseButton() {
        buttonClose = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleClose))
        items.append(buttonClose!)
    }
    
    func addMsgButton() {
        buttonMsg = UIBarButtonItem(image: UIImage(named: "message")?.withRenderingMode(.alwaysTemplate),
        style: .plain, target: self, action: #selector(toggleMsg))
        items.append(buttonMsg!)
    }
    
    func addToolBarButtons() {
        items.removeAll()
        addToolBarSpace()
        addTimerLabel()
        addMicButton()
        addVideoButton()
        if (publisherRole == "MMD") {
            //addRecordButton()
            //addPrintButton()
        }
        //addArchiveButton()
        addCloseButton()
        //addMsgButton()
        addToolBarSpace()
        tbButtons!.setItems(items, animated: true)
    }
    
    func connectToAnOpenTokSession() {
        session = OTSession(apiKey: kApiKey, sessionId: kSessionId, delegate: self)
        var error: OTError?
        session?.connect(withToken: kToken, error: &error)
        if error != nil {
            print(error!)
        }
    }
    
    func defineViewPos() -> Int {
        var returnPos:Int?
        for i in 0...3 {
            if (pubViewPos != i) {
                if (subViewPos != i) {
                    if (subViewPos2 != i) {
                        if (subViewPos3 != i) {
                            returnPos=i
                            break
                        }
                    }
                }
            }
        }
        if (returnPos == nil) { returnPos = 0 }
        return returnPos!
    }
    
    func resizePublisherView(_ screenSize: CGSize) {
        if(publisher != nil) {
            var posX:Int?
            var posY:Int?
            var viewWidth:Int?
            var viewHeight:Int?
            if (pubViewPos == 0) {
                posY = Int(self.topLayoutGuide.length)
                posX = 0
                viewWidth = Int(screenSize.width)
                viewHeight = Int(screenSize.height - tbButtons!.frame.height) - posY!
            } else {
                viewWidth = Int((screenSize.width - 80) / 3)
                viewHeight = Int((viewWidth!) * 3 / 4)
                posY = Int(screenSize.height) - viewHeight! - 20 - Int(tbButtons!.frame.height)
                if (pubViewPos == 1) {
                    posX = Int(screenSize.width) - viewWidth! - 20
                } else if (pubViewPos == 2) {
                    posX = Int(screenSize.width) - ((viewWidth! + 20) * 2)
                } else if (pubViewPos == 3) {
                    posX = 20
                } else {
                    posX = 0
                }
            }
            publisherView?.frame = CGRect(x: posX!, y: posY!, width: viewWidth!, height: viewHeight!)
            if (pubViewPos == 0) {
                view.sendSubview(toBack: publisherView!)
            } else {
                view.bringSubview(toFront: publisherView!)
            }
        }
    }
    
    func resizeSubscriberView(_ screenSize: CGSize) {
        if ((subscriber) != nil) {
            var posX:Int?
            var posY:Int?
            var viewWidth:Int?
            var viewHeight:Int?
            if (subViewPos == 0) {
                posY = Int(self.topLayoutGuide.length)
                posX = 0
                viewWidth = Int(screenSize.width)
                viewHeight = Int(screenSize.height - tbButtons!.frame.height) - posY!
            } else {
                viewWidth = Int((screenSize.width - 80) / 3)
                viewHeight = Int((viewWidth!) * 3 / 4)
                posY = Int(screenSize.height) - viewHeight! - 20 - Int(tbButtons!.frame.height)
                if (subViewPos == 1) {
                    posX = Int(screenSize.width) - viewWidth! - 20
                } else if (subViewPos == 2) {
                    posX = Int(screenSize.width) - ((viewWidth! + 20) * 2)
                } else if (subViewPos == 3) {
                    posX = 20
                } else {
                    posX = 0
                }
            }
            subscriberView?.frame = CGRect(x: posX!, y: posY!, width: viewWidth!, height: viewHeight!)
            if (subViewPos == 0) {
                view.sendSubview(toBack: subscriberView!)
            } else {
                view.bringSubview(toFront: subscriberView!)
            }
        }
    }
    
    func resizeSubscriberView2(_ screenSize: CGSize) {
        if ((subscriber2) != nil) {
            var posX:Int?
            var posY:Int?
            var viewWidth:Int?
            var viewHeight:Int?
            if (subViewPos2 == 0) {
                posY = Int(self.topLayoutGuide.length)
                posX = 0
                viewWidth = Int(screenSize.width)
                viewHeight = Int(screenSize.height - tbButtons!.frame.height) - posY!
            } else {
                viewWidth = Int((screenSize.width - 80) / 3)
                viewHeight = Int((viewWidth!) * 3 / 4)
                posY = Int(screenSize.height) - viewHeight! - 20 - Int(tbButtons!.frame.height)
                if (subViewPos2 == 1) {
                    posX = Int(screenSize.width) - viewWidth! - 20
                } else if (subViewPos2 == 2) {
                    posX = Int(screenSize.width) - ((viewWidth! + 20) * 2)
                } else if (subViewPos2 == 3) {
                    posX = 20
                } else {
                    posX = 0
                }
            }
            subscriberView2?.frame = CGRect(x: posX!, y: posY!, width: viewWidth!, height: viewHeight!)
            if (subViewPos2 == 0) {
                view.sendSubview(toBack: subscriberView2!)
            } else {
                view.bringSubview(toFront: subscriberView2!)
            }
        }
    }
    
    func resizeSubscriberView3(_ screenSize: CGSize) {
        if ((subscriber3) != nil) {
            var posX:Int?
            var posY:Int?
            var viewWidth:Int?
            var viewHeight:Int?
            if (subViewPos3 == 0) {
                posY = Int(self.topLayoutGuide.length)
                posX = 0
                viewWidth = Int(screenSize.width)
                viewHeight = Int(screenSize.height - tbButtons!.frame.height) - posY!
            } else {
                viewWidth = Int((screenSize.width - 80) / 3)
                viewHeight = Int((viewWidth!) * 3 / 4)
                posY = Int(screenSize.height) - viewHeight! - 20 - Int(tbButtons!.frame.height)
                if (subViewPos3 == 1) {
                    posX = Int(screenSize.width) - viewWidth! - 20
                } else if (subViewPos3 == 2) {
                    posX = Int(screenSize.width) - ((viewWidth! + 20) * 2)
                } else if (subViewPos3 == 3) {
                    posX = 20
                } else {
                    posX = 0
                }
            }
            subscriberView3?.frame = CGRect(x: posX!, y: posY!, width: viewWidth!, height: viewHeight!)
            if (subViewPos3 == 0) {
                view.sendSubview(toBack: subscriberView3!)
            } else {
                view.bringSubview(toFront: subscriberView3!)
            }
        }
    }
    
    @objc func toggleMic(sender: UIButton!) {
        if (publisher != nil && publisherView != nil) {
            if publisher?.publishAudio == false {
                publisher!.publishAudio=true
                buttonMic!.image = UIImage(named: "mic-on")?.withRenderingMode(.alwaysTemplate)
            } else {
                publisher!.publishAudio=false
                buttonMic!.image = UIImage(named: "mic-off")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    @objc func toggleCam(sender: UIButton!) {
        if (publisher != nil && publisherView != nil) {
            if publisher?.publishVideo == false {
                publisher!.publishVideo = true
                buttonCam!.image = UIImage(named: "video-on")?.withRenderingMode(.alwaysTemplate)
            } else {
                publisher!.publishVideo = false
                buttonCam!.image = UIImage(named: "video-off")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    @objc func toggleMicSub(sender: UIButton!) {
        if (subscriber != nil) {
            if subscriber?.subscribeToAudio == false {
                subscriber!.subscribeToAudio=true
                buttonMicSub!.image = UIImage(named: "volume-on")?.withRenderingMode(.alwaysTemplate)
            } else {
                subscriber!.subscribeToAudio=false
                buttonMicSub!.image = UIImage(named: "volume-off")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    @objc func toggleMicSub2(sender: UIButton!) {
        if subscriber2?.subscribeToAudio == false {
            subscriber2!.subscribeToAudio=true
            buttonMicSub2!.image = UIImage(named: "volume-on")?.withRenderingMode(.alwaysTemplate)
        } else {
            subscriber2!.subscribeToAudio=false
            buttonMicSub2!.image = UIImage(named: "volume-off")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc func toggleMicSub3(sender: UIButton!) {
        if subscriber3?.subscribeToAudio == false {
            subscriber3!.subscribeToAudio=true
            buttonMicSub3!.image = UIImage(named: "volume-on")?.withRenderingMode(.alwaysTemplate)
        } else {
            subscriber3!.subscribeToAudio=false
            buttonMicSub3!.image = UIImage(named: "volume-off")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @objc func toggleCamPub(sender: UITapGestureRecognizer!) {
        if (pubViewPos != nil) {
            if (pubViewPos != 0) {
                if (subscriberView != nil) {
                    if (subViewPos == 0) {
                        subViewPos! = pubViewPos!
                        resizeSubscriberView(screenBounds.size)
                    }
                }
                if (subscriberView2 != nil) {
                    if (subViewPos2 == 0) {
                        subViewPos2! = pubViewPos!
                        resizeSubscriberView2(screenBounds.size)
                    }
                }
                if (subscriberView3 != nil) {
                    if (subViewPos3 == 0) {
                        subViewPos3! = pubViewPos!
                        resizeSubscriberView3(screenBounds.size)
                    }
                }
                pubViewPos! = 0
                resizePublisherView(screenBounds.size)
            }
        }
    }
    
    @objc func toggleCamSub(sender: UITapGestureRecognizer!) {
        if (subViewPos != nil) {
            if (subViewPos != 0) {
                if (publisherView != nil) {
                    if (pubViewPos == 0) {
                        pubViewPos! = subViewPos!
                        resizePublisherView(screenBounds.size)
                    }
                }
                if (subscriberView2 != nil) {
                    if (subViewPos2 == 0) {
                        subViewPos2! = subViewPos!
                        resizeSubscriberView2(screenBounds.size)
                    }
                }
                if (subscriberView3 != nil) {
                    if (subViewPos3 == 0) {
                        subViewPos3! = subViewPos!
                        resizeSubscriberView3(screenBounds.size)
                    }
                }
                subViewPos! = 0
                resizeSubscriberView(screenBounds.size)
            }
        }
    }
    
    @objc func toggleCamSub2(sender: UITapGestureRecognizer!) {
        if (subViewPos2 != nil) {
            if (subViewPos2 != 0) {
                if (publisherView != nil) {
                    if (pubViewPos == 0) {
                        pubViewPos! = subViewPos2!
                        resizePublisherView(screenBounds.size)
                    }
                }
                if (subscriberView != nil) {
                    if (subViewPos == 0) {
                        subViewPos! = subViewPos2!
                        resizeSubscriberView(screenBounds.size)
                    }
                }
                if (subscriberView3 != nil) {
                    if (subViewPos3 == 0) {
                        subViewPos3! = subViewPos2!
                        resizeSubscriberView3(screenBounds.size)
                    }
                }
                subViewPos2! = 0
                resizeSubscriberView2(screenBounds.size)
            }
        }
    }
    
    @objc func toggleCamSub3(sender: UITapGestureRecognizer!) {
        if (subViewPos3 != nil) {
            if (subViewPos3 != 0) {
                if (publisherView != nil) {
                    if (pubViewPos == 0) {
                        pubViewPos! = subViewPos3!
                        resizePublisherView(screenBounds.size)
                    }
                }
                if (subscriberView2 != nil) {
                    if (subViewPos2 == 0) {
                        subViewPos2! = subViewPos3!
                        resizeSubscriberView2(screenBounds.size)
                    }
                }
                if (subscriberView != nil) {
                    if (subViewPos == 0) {
                        subViewPos! = subViewPos3!
                        resizeSubscriberView(screenBounds.size)
                    }
                }
                subViewPos3! = 0
                resizeSubscriberView3(screenBounds.size)
            }
        }
    }
    
    @objc func toggleRecord(sender: UIButton!) {
        
    }
    
    @objc func togglePrint(sender: UIButton!) {
        
    }
    
    @objc func toggleShare(sender: UIButton!) {
        
    }
    
    @objc func toggleArchive(sender: UIButton!) {
        
    }
    
    @objc func toggleClose(sender: UIButton!) {
        var error: OTError?
        if (publisherRole == "MMD") {
            
        }
        if (publisher != nil) {
            session!.unpublish(publisher!, error: &error)
            publisherView?.removeFromSuperview()
            publisherView = nil
            publisher = nil
            publisher?.publishVideo = false
            publisher?.publishAudio = false
        }
        if (subscriber != nil) {
            session!.unsubscribe(subscriber!, error: &error)
            subscriberView?.removeFromSuperview()
            subscriberView = nil
            subscriber = nil
            subscriber?.subscribeToVideo = false
            subscriber?.subscribeToAudio = false
        }
        if (subscriber2 != nil) {
            session!.unsubscribe(subscriber2!, error: &error)
            subscriberView2?.removeFromSuperview()
            subscriberView2 = nil
            subscriber2 = nil
            subscriber2?.subscribeToVideo = false
            subscriber2?.subscribeToAudio = false
        }
        if (subscriber3 != nil) {
            session!.unsubscribe(subscriber3!, error: &error)
            subscriberView3?.removeFromSuperview()
            subscriberView3 = nil
            subscriber3 = nil
            subscriber3?.subscribeToVideo = false
            subscriber3?.subscribeToAudio = false
        }
        self.closeView()
    }
    
    @objc func toggleMsg(sender: UIButton!) {
        
    }
    
    // MARK: - OTSessionDelegate callbacks
    public func sessionDidConnect(_ session: OTSession) {
        print("The client connected to the OpenTok session.")
        
        let settings = OTPublisherSettings()
        settings.name = self.publisherName
        
        publisher = OTPublisher(delegate: self, settings:settings)
        guard (publisher != nil) else {
            return
        }
        
        var error: OTError?
        session.publish(publisher!, error: &error)
        guard error == nil else {
            print(error!)
            return
        }
        
        publisherView = publisher?.view
        guard (publisherView != nil) else {
            return
        }
        //torna a tela do publisher como secundária
        if (pubViewPos == nil) {
            if (subViewPos == nil && subViewPos2 == nil && subViewPos3 == nil) {
                pubViewPos = 1
            } else {
                pubViewPos = self.defineViewPos()
            }
        }
        // cria o tap gesture
        tapPubView = UITapGestureRecognizer(target: self, action: #selector(toggleCamPub))
        publisherView!.isUserInteractionEnabled = true
        publisherView!.addGestureRecognizer(tapPubView!)
        //cria a publisherView
        let screenBounds = UIScreen.main.bounds
        view.addSubview(publisherView!)
        resizePublisherView(screenBounds.size)
        //cria os botões
        addToolBarButtons()
        //toolbar da view
        publisherToolBar = UIToolbar()
        publisherToolBar!.barStyle = UIBarStyle.default
        publisherToolBar?.isTranslucent = true
        publisherToolBar?.frame = CGRect(x: 0, y: 0, width: publisherView!.frame.width, height: 30)
        publisherView?.addSubview(publisherToolBar!)
        publisherToolBar?.translatesAutoresizingMaskIntoConstraints = false
        publisherToolBar?.leadingAnchor.constraint(equalTo: publisherView!.leadingAnchor).isActive = true
        publisherToolBar?.trailingAnchor.constraint(equalTo: publisherView!.trailingAnchor).isActive = true
        publisherToolBar?.topAnchor.constraint(equalTo: publisherView!.topAnchor).isActive = true
        //Adiciona os itens da Toolbar
        itemsPub.append(UIBarButtonItem(title: publisherName, style: .plain, target: nil, action: nil))
        publisherToolBar!.setItems(itemsPub, animated: true)
        publisherToolBar!.tintColor = davTextColorVideoHeaderParticipant
        publisherToolBar!.barTintColor = davBackgroundVideoHeaderParticipant
        self.removeSpinner()
        self.runTimer()
        
    }

    public func sessionDidDisconnect(_ session: OTSession) {
        print("The client disconnected from the OpenTok session.")
    }

    public func session(_ session: OTSession, didFailWithError error: OTError) {
        print("The client failed to connect to the OpenTok session: \(error).")
    }

    public func session(_ session: OTSession, streamCreated stream: OTStream) {
        if(subscriber != nil) {
            if (subscriber2 != nil) {
                if (subscriber3 != nil) {
                    //já existem outros 2
                    return
                } else {
                    print("A stream (3) was created in the session.")
                    subscriber3 = OTSubscriber(stream: stream, delegate: self)
                    guard (subscriber3 != nil) else {
                        return
                    }
                    var error: OTError?
                    session.subscribe(subscriber3!, error: &error)
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    subscriberView3 = subscriber3!.view
                    guard (subscriberView3 != nil) else {
                        return
                    }
                    //torna o subscriberview como maior
                    if (subViewPos3 == nil) { subViewPos3 = self.defineViewPos() }
                    //cria o subscriberview
                    view.addSubview(subscriberView3!)
                    resizeSubscriberView3(UIScreen.main.bounds.size)
                    //pega o nome do Subscriber
                    subscriberName3 = (subscriber3!.stream?.name)!
                    //Define o toolbar
                    subscriberToolBar3 = UIToolbar()
                    subscriberToolBar3!.barStyle = UIBarStyle.default
                    subscriberToolBar3!.isTranslucent = true
                    subscriberToolBar3!.barTintColor = davBackgroundVideoHeaderParticipant
                    subscriberToolBar3!.tintColor = davTextColorVideoHeaderParticipant
                    subscriberView3!.addSubview(subscriberToolBar3!)
                    subscriberToolBar3!.translatesAutoresizingMaskIntoConstraints = false
                    subscriberToolBar3!.leadingAnchor.constraint(equalTo: subscriberView3!.leadingAnchor).isActive = true
                    subscriberToolBar3!.trailingAnchor.constraint(equalTo: subscriberView3!.trailingAnchor).isActive = true
                    subscriberToolBar3!.topAnchor.constraint(equalTo: subscriberView3!.topAnchor).isActive = true
                    //Adiciona os itens da Toolbar
                    itemsSub3.append(UIBarButtonItem(title: subscriberName3, style: .plain, target: nil, action: nil))
                    itemsSub3.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
                    buttonMicSub3 = UIBarButtonItem(image: UIImage(named: "vvolume-on")?.withRenderingMode(.alwaysTemplate),
                    style: .plain, target: self, action: #selector(toggleMicSub3))
                    itemsSub3.append(buttonMicSub3!)
                    subscriberToolBar3!.setItems(itemsSub3, animated: true)
                }
            } else {
                print("A stream (2) was created in the session.")
                subscriber2 = OTSubscriber(stream: stream, delegate: self)
                guard (subscriber2 != nil) else {
                    return
                }
                var error: OTError?
                session.subscribe(subscriber2!, error: &error)
                guard error == nil else {
                    print(error!)
                    return
                }
                subscriberView2 = subscriber2!.view
                guard (subscriberView2 != nil) else {
                    return
                }
                //torna o subscriberview como maior
                if (subViewPos2 == nil) { subViewPos2 = self.defineViewPos() }
                //cria o subscriberview
                view.addSubview(subscriberView2!)
                resizeSubscriberView2(UIScreen.main.bounds.size)
                //pega o nome do Subscriber
                subscriberName2 = (subscriber2!.stream?.name)!
                //Define o toolbar
                subscriberToolBar2 = UIToolbar()
                subscriberToolBar2!.barStyle = UIBarStyle.default
                subscriberToolBar2!.isTranslucent = true
                subscriberToolBar2!.barTintColor = davBackgroundVideoHeaderParticipant
                subscriberToolBar2!.tintColor = davTextColorVideoHeaderParticipant
                subscriberView2!.addSubview(subscriberToolBar2!)
                subscriberToolBar2!.translatesAutoresizingMaskIntoConstraints = false
                subscriberToolBar2!.leadingAnchor.constraint(equalTo: subscriberView2!.leadingAnchor).isActive = true
                subscriberToolBar2!.trailingAnchor.constraint(equalTo: subscriberView2!.trailingAnchor).isActive = true
                subscriberToolBar2!.topAnchor.constraint(equalTo: subscriberView2!.topAnchor).isActive = true
                //Adiciona os itens da Toolbar
                itemsSub2.append(UIBarButtonItem(title: subscriberName2, style: .plain, target: nil, action: nil))
                itemsSub2.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
                buttonMicSub2 = UIBarButtonItem(image: UIImage(named: "volume-on")?.withRenderingMode(.alwaysTemplate),
                style: .plain, target: self, action: #selector(toggleMicSub2))
                itemsSub2.append(buttonMicSub2!)
                subscriberToolBar2!.setItems(itemsSub2, animated: true)
            }
        } else {
            print("A stream (1) was created in the session.")
            subscriber = OTSubscriber(stream: stream, delegate: self)
            guard (subscriber != nil) else {
                return
            }
            var error: OTError?
            session.subscribe(subscriber!, error: &error)
            guard error == nil else {
                print(error!)
                return
            }
            subscriberView = subscriber!.view
            guard (subscriberView != nil) else {
                return
            }
            //torna o subscriberview como maior
            if (subViewPos == nil) { subViewPos = self.defineViewPos() }
            // cria o tap gesture
            tapSubView = UITapGestureRecognizer(target: self, action: #selector(toggleCamSub))
            subscriberView!.isUserInteractionEnabled = true
            subscriberView!.addGestureRecognizer(tapSubView!)
            //cria o subscriberview
            view.addSubview(subscriberView!)
            resizeSubscriberView(UIScreen.main.bounds.size)
            //pega o nome do Subscriber
            subscriberName = (subscriber!.stream?.name)!
            //Define o toolbar
            subscriberToolBar = UIToolbar()
            subscriberToolBar!.barStyle = UIBarStyle.default
            subscriberToolBar!.isTranslucent = true
            subscriberToolBar!.barTintColor = davBackgroundVideoHeaderParticipant
            subscriberToolBar!.tintColor = davTextColorVideoHeaderParticipant
            subscriberView!.addSubview(subscriberToolBar!)
            subscriberToolBar!.translatesAutoresizingMaskIntoConstraints = false
            subscriberToolBar!.leadingAnchor.constraint(equalTo: subscriberView!.leadingAnchor).isActive = true
            subscriberToolBar!.trailingAnchor.constraint(equalTo: subscriberView!.trailingAnchor).isActive = true
            subscriberToolBar!.topAnchor.constraint(equalTo: subscriberView!.topAnchor).isActive = true
            // Adiciona os itens da Toolbar
            itemsSub.append(UIBarButtonItem(title: subscriberName, style: .plain, target: nil, action: nil))
            itemsSub.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
            buttonMicSub = UIBarButtonItem(image: UIImage(named: "volume-on")?.withRenderingMode(.alwaysTemplate),
            style: .plain, target: self, action: #selector(toggleMicSub))
            itemsSub.append(buttonMicSub!)
            subscriberToolBar!.setItems(itemsSub, animated: true)
        }
    }
    
    public func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("A stream was destroyed in the session.")
        if (subscriber?.session == nil && subscriberView != nil) {
            alertMsg = subscriberName + " saiu da sala"
            subscriberView?.removeFromSuperview()
            subViewPos = nil
            subscriber = nil
            subscriberView = nil
            subscriberName = ""
            self.showAlert(self)
        }
        if (subscriber2?.session == nil && subscriberView2 != nil) {
            alertMsg = subscriberName2 + " saiu da sala"
            subscriberView2?.removeFromSuperview()
            subViewPos2 = nil
            subscriber2 = nil
            subscriberView2 = nil
            subscriberName2 = ""
            self.showAlert(self)
        }
        if (subscriber3?.session == nil && subscriberView3 != nil) {
            alertMsg = subscriberName3 + " saiu da sala"
            subscriberView3?.removeFromSuperview()
            subViewPos3 = nil
            subscriber3 = nil
            subscriberView3 = nil
            subscriberName3 = ""
            self.showAlert(self)
        }
    }
    
    // MARK: - OTPublisherDelegate callbacks
    public func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("The publisher failed: \(error)")
    }
    
    // MARK: - OTSubscriberDelegate callbacks
    public func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
        print("The subscriber did connect to the stream.")
        
    }

    public func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("The subscriber failed to connect to the stream.")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
