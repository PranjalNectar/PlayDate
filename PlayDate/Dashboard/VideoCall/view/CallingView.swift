//
//  CallingView.swift
//  PlayDate
//
//  Created by Pranjal on 27/07/21.
//

//import SwiftUI
//import Quickblox
//import QuickbloxWebRTC
//import SVProgressHUD
//
//struct CallingView: View {
//
//    @State var title = ""
//  
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//            
//            
//            .onAppear{
//                QBRTCAudioSession.instance().addDelegate(videocalling())
//                
//                if self.session != nil {
//                    QBRTCClient.instance().add(videocalling() as QBRTCClientDelegate)
//                } else {
//                    CallKitManager.instance.delegate = videocalling()
//                }
//                
//                let profile = Profile()
//                
//                guard profile.isFull == true, let currentConferenceUser = Profile.currentUser() else {
//                    return
//                }
//                
//                let conferenceType = self.session != nil ? self.session?.conferenceType : sessionConferenceType
//                if conferenceType == .video {
//                    #if targetEnvironment(simulator)
//                    // Simulator
//                    #else
//                    // Device
//                    cameraCapture.startSession(nil)
//                    session?.localMediaStream.videoTrack.videoCapture = cameraCapture
//                    #endif
//                }
//                
//                configureGUI()
//                
////                opponentsCollectionView.collectionViewLayout = OpponentsFlowLayout()
////                opponentsCollectionView.backgroundColor = UIColor(red: 0.1465,
////                                                                  green: 0.1465,
////                                                                  blue: 0.1465,
////                                                                  alpha: 1.0)
////                view.backgroundColor = opponentsCollectionView.backgroundColor
////
////                users.insert(currentConferenceUser, at: 0)
//                title = CallStateConstant.connecting
//                
//                if let session = self.session {
//                    setupSession(session)
//                }
//            }
//    }
//}
//
//struct CallingView_Previews: PreviewProvider {
//    static var previews: some View {
//        CallingView()
//    }
//}
//
//
//
//extension videocalling: QBRTCAudioSessionDelegate {
//    //MARK: QBRTCAudioSessionDelegate
//    func audioSession(_ audioSession: QBRTCAudioSession, didChangeCurrentAudioDevice updatedAudioDevice: QBRTCAudioDevice) {
//        let isSpeaker = updatedAudioDevice == .speaker
//        dynamicButton.pressed = isSpeaker
//    }
//}
//
//// MARK: QBRTCClientDelegate
//extension videocalling: QBRTCClientDelegate {
//    
//    func session(_ session: QBRTCBaseSession, disconnectedFromUser userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session,
//            let opponentsIDsCount = self.session?.opponentsIDs.count  else {
//                return
//        }
//        if opponentsIDsCount == 1 {
//            closeCall()
//        } else {
//            if disconnectedUsers.contains(userID.uintValue) == false {
//                disconnectedUsers.append(userID.uintValue)
//            }
//            if disconnectedUsers.count == opponentsIDsCount {
//                closeCall()
//            }
//        }
//    }
//    
//    func session(_ session: QBRTCSession, rejectedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//        if session == self.session, session.opponentsIDs.count == 1 {
//            closeCall()
//        }
//    }
//    
//    func session(_ session: QBRTCSession, hungUpByUser userID: NSNumber, userInfo: [String : String]? = nil) {
//        if session == self.session, session.opponentsIDs.count == 1 {
//            closeCall()
//        }
//    }
//    
//    func session(_ session: QBRTCBaseSession, updatedStatsReport report: QBRTCStatsReport, forUserID userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session else {
//                return
//        }
//        
//        var existingUser: User?
//        if let user = users.filter({ $0.userID == userID.uintValue }).first {
//            existingUser = user
//        }
//        
//        let profile = Profile()
//        let isInitiator = profile.ID == qbSession.initiatorID.uintValue
//        if isInitiator == false && existingUser == nil {
//            if let user = createConferenceUser(userID: userID.uintValue) {
//                self.users.insert(user, at: 0)
//                reloadContent()
//            } else {
//                usersDataSource?.loadUser(userID.uintValue, completion: { [weak self] (user) in
//                    if let user = self?.createConferenceUser(userID: userID.uintValue) {
//                        self?.users.insert(user, at: 0)
//                        self?.reloadContent()
//                    }
//                })
//            }
//        }
//        
//        guard let user = users.filter({ $0.userID == userID.uintValue }).first else {
//            return
//        }
//        
//        if user.connectionState == .connected,
//            report.videoReceivedBitrateTracker.bitrate > 0.0 {
//            user.bitrate = report.videoReceivedBitrateTracker.bitrate
//            
//           if let userIndexPath = self.userIndexPath(userID: user.userID),
//            let cell = self.opponentsCollectionView.cellForItem(at: userIndexPath) as? UserCell {
//                cell.bitrate = user.bitrate
//            }
//        }
//        
//        guard let selectedUserID = statsUserID,
//            selectedUserID == userID.uintValue,
//            shouldGetStats == true else {
//                return
//        }
//        let result = report.statsString()
//        statsView.updateStats(result)
//    }
//    
//    /**
//     *  Called in case when connection state changed
//     */
//    func session(_ session: QBRTCBaseSession, connectionClosedForUser userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session else {
//                return
//        }
//        // remove user from the collection
//        if statsUserID == userID.uintValue {
//            unzoomUser()
//        }
//        
//        guard let index = users.index(where: { $0.userID == userID.uintValue }) else {
//            return
//        }
//        let user = users[index]
//        if user.connectionState == .connected {
//            return
//        }
//        
//        user.bitrate = 0.0
//        
//        if let videoView = videoViews[userID.uintValue] as? QBRTCRemoteVideoView {
//            videoView.removeFromSuperview()
//            videoViews.removeValue(forKey: userID.uintValue)
//            let remoteVideoView = QBRTCRemoteVideoView(frame: CGRect(x: 2.0, y: 2.0, width: 2.0, height: 2.0))
//            remoteVideoView.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
//            videoViews[userID.uintValue] = remoteVideoView
//        }
//        reloadContent()
//    }
//    
//    /**
//     *  Called in case when connection state changed
//     */
//    func session(_ session: QBRTCBaseSession, didChange state: QBRTCConnectionState, forUser userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session,
//            let opponentsIDsCount = self.session?.opponentsIDs.count  else {
//                return
//        }
//        
//        if let index = users.index(where: { $0.userID == userID.uintValue }) {
//            let user = users[index]
//            if user.connectionState != .hangUp {
//                user.connectionState = state
//            }
//           if let userIndexPath = self.userIndexPath(userID:userID.uintValue),
//            let cell = self.opponentsCollectionView.cellForItem(at: userIndexPath) as? UserCell {
//                cell.connectionState = user.connectionState
//            }
//        } else {
//            if let user = createConferenceUser(userID: userID.uintValue) {
//                user.connectionState = state
//                if user.connectionState == .connected {
//                    self.users.insert(user, at: 0)
//                    reloadContent()
//                }
//            } else {
//                usersDataSource?.loadUser(userID.uintValue, completion: { [weak self] (user) in
//                    if let user = self?.createConferenceUser(userID: userID.uintValue) {
//                        user.connectionState = state
//                        if user.connectionState == .connected {
//                            self?.users.insert(user, at: 0)
//                            self?.reloadContent()
//                        }
//                    }
//                })
//            }
//        }
//        
//        let profile = Profile()
//        if profile.ID == userID.uintValue {
//            return
//        }
//        if state == .disconnected ||
//            state == .hangUp ||
//            state == .rejected ||
//            state == .closed ||
//            state == .failed {
//            if opponentsIDsCount == 1 {
//                closeCall()
//            } else {
//                if disconnectedUsers.contains(userID.uintValue) == false {
//                    disconnectedUsers.append(userID.uintValue)
//                }
//                if disconnectedUsers.count == opponentsIDsCount {
//                    closeCall()
//                }
//            }
//        }
//    }
//    
//    /**
//     *  Called in case when receive remote video track from opponent
//     */
//    func session(_ session: QBRTCBaseSession,
//                 receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack,
//                 fromUser userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session else {
//                return
//        }
//       // reloadContent()
//    }
//    
//    /**
//     *  Called in case when connection is established with opponent
//     */
//    func session(_ session: QBRTCBaseSession, connectedToUser userID: NSNumber) {
//        guard let qbSession = session as? QBRTCSession,
//            qbSession == self.session else {
//                return
//        }
//        
//        if let beepTimer = beepTimer {
//            beepTimer.invalidate()
//            self.beepTimer = nil
//            SoundProvider.stopSound()
//        }
//        
//        if callTimer == nil {
//            let profile = Profile()
//            if profile.isFull == true,
//                self.session?.initiatorID.uintValue == profile.ID {
//                CallKitManager.instance.updateCall(with: callUUID, connectedAt: Date())
//            }
//            
//            callTimer = Timer.scheduledTimer(timeInterval: CallConstant.refreshTimeInterval,
//                                             target: self,
//                                             selector: #selector(refreshCallTime(_:)),
//                                             userInfo: nil,
//                                             repeats: true)
//        }
//    }
//    
//    func sessionDidClose(_ session: QBRTCSession) {
//        if let sessionID = self.session?.id,
//            sessionID == session.id {
//            closeCall()
//        }
//    }
//}
//
//
//extension videocalling: CallKitManagerDelegate {
//    func callKitManager(_ callKitManager: CallKitManager, didUpdateSession session: QBRTCSession) {
//        if self.session == nil {
//            QBRTCClient.instance().add(self as QBRTCClientDelegate)
////            QBRTCAudioSession.instance().addDelegate(self)
//            CallKitManager.instance.delegate = nil
//            self.session = session
//            setupSession(session)
//        }
//    }
//}
//
//
//class videocalling{
//    
//    
//    var title = ""
//    //MARK: - Properties
//    weak var usersDataSource: UsersDataSource?
//    
//    //MARK: - Internal Properties
//    private var timeDuration: TimeInterval = 0.0
//    
//    private var callTimer: Timer?
//    private var beepTimer: Timer?
//    
//    //Camera
//    var session: QBRTCSession?
//    
//    var sessionConferenceType: QBRTCConferenceType = QBRTCConferenceType.audio
//    var callUUID: UUID?
//    lazy private var cameraCapture: QBRTCCameraCapture = {
//        let settings = Settings()
//        let cameraCapture = QBRTCCameraCapture(videoFormat: settings.videoFormat,
//                                               position: settings.preferredCameraPostion)
//        cameraCapture.startSession(nil)
//        return cameraCapture
//    }()
//    
//    //Containers
//    private var users = [User]()
//    private var videoViews = [UInt: UIView]()
//    private var statsUserID: UInt?
//    private var disconnectedUsers = [UInt]()
//    
//    //Views
//    lazy private var dynamicButton: CustomButton = {
//        let dynamicButton = ButtonsFactory.dynamicEnable()
//        return dynamicButton
//    }()
//    
//    lazy private var audioEnabled: CustomButton = {
//        let audioEnabled = ButtonsFactory.audioEnable()
//        return audioEnabled
//    }()
//    
//    private var localVideoView: LocalVideoView?
//    
//    lazy private var statsView: StatsView = {
//        let statsView = StatsView()
//        return statsView
//    }()
//    
//    private lazy var statsItem = UIBarButtonItem(title: "Stats",
//                                                 style: .plain,
//                                                 target: self,
//                                                 action: #selector(updateStatsView))
//    
//    
//    //States
//    private var shouldGetStats = false
//    private var didStartPlayAndRecord = false
//    private var muteVideo = false {
//        didSet {
//            session?.localMediaStream.videoTrack.isEnabled = !muteVideo
//        }
//    }
//    
//    private var state = CallViewControllerState.connected {
//        didSet {
//            switch state {
//            case .disconnected:
//                title = CallStateConstant.disconnected
//            case .connecting:
//                title = CallStateConstant.connecting
//            case .connected:
//                title = CallStateConstant.connected
//            case .disconnecting:
//                title = CallStateConstant.disconnecting
//            }
//        }
//    }
//    
//    
//    //MARK - Setup
//    private func setupSession(_ session: QBRTCSession) {
//        if session.conferenceType != sessionConferenceType {
////            toolbar.removeAllButtons()
////            toolbar.updateItems()
////            configureGUI()
//        }
//        
//        if session.conferenceType == .video {
//            #if targetEnvironment(simulator)
//            // Simulator
//            #else
//            // Device
//            
//            if cameraCapture.hasStarted == false {
//                cameraCapture.startSession(nil)
//            }
//            session.localMediaStream.videoTrack.videoCapture = cameraCapture
//            #endif
//        }
//
//        if session.opponentsIDs.isEmpty == false {
//            let isInitiator = users[0].userID == session.initiatorID.uintValue
//            if isInitiator == true {
//                let audioSession = QBRTCAudioSession.instance()
//                audioSession.useManualAudio = true
//                audioSession.isAudioEnabled = true
//                // disabling audio unit for local mic recording in recorder to enable it later
//                session.recorder?.isLocalAudioEnabled = false
//                if audioSession.isInitialized == false {
//                    audioSession.initialize { configuration in
//                        // adding blutetooth support
//                        configuration.categoryOptions.insert(.allowBluetooth)
//                        configuration.categoryOptions.insert(.allowBluetoothA2DP)
//                        configuration.categoryOptions.insert(.duckOthers)
//                        // adding airplay support
//                        configuration.categoryOptions.insert(.allowAirPlay)
//                        if session.conferenceType == .video {
//                            // setting mode to video chat to enable airplay audio and speaker only
//                            configuration.mode = AVAudioSession.Mode.videoChat.rawValue
//                        } else if session.conferenceType == .audio {
//                            // setting mode to video chat to enable airplay audio and speaker only
//                            configuration.mode = AVAudioSession.Mode.voiceChat.rawValue
//                        }
//                    }
//                }
//                startCall()
//                CallKitManager.instance.updateCall(with: callUUID, connectingAt: Date())
//                
//            } else {
//                acceptCall()
//            }
//        }
//    }
//    
//    private func configureGUI() {
//        // when conferenceType is nil, it means that user connected to the session as a listener
//        guard let conferenceType = self.session != nil ? self.session?.conferenceType : sessionConferenceType else {return}
//        
//        switch conferenceType {
//        case .video:
//            toolbar.add(ButtonsFactory.videoEnable(), action: { [weak self] sender in
//                if let muteVideo = self?.muteVideo {
//                    self?.muteVideo = !muteVideo
//                    self?.localVideoView?.isHidden = !muteVideo
//                }
//            })
//            toolbar.add(ButtonsFactory.screenShare(), action: { [weak self] sender in
//                guard let self = self else {
//                    return
//                }
//                guard let sharingVC = self.storyboard?.instantiateViewController(withIdentifier: CallConstant.sharingViewControllerIdentifier) as? SharingViewController else {
//                    return
//                }
//                self.title = "Call"
//                sharingVC.session = self.session
//                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: nil, action: nil)
//                self.navigationController?.pushViewController(sharingVC, animated: true)
//                
//            })
//        case .audio:
//            if UIDevice.current.userInterfaceIdiom == .phone {
//                QBRTCAudioSession.instance().currentAudioDevice = .receiver
//                dynamicButton.pressed = false
//                
//                toolbar.add(dynamicButton, action: { sender in
//                    let previousDevice = QBRTCAudioSession.instance().currentAudioDevice
//                    let device = previousDevice == .speaker ? QBRTCAudioDevice.receiver : QBRTCAudioDevice.speaker
//                    QBRTCAudioSession.instance().currentAudioDevice = device
//                })
//            }
//        }
//        
//        session?.localMediaStream.audioTrack.isEnabled = true;
//        toolbar.add(audioEnabled, action: { [weak self] sender in
//            guard let self = self else {return}
//            
//            if let muteAudio = self.session?.localMediaStream.audioTrack.isEnabled {
//                self.session?.localMediaStream.audioTrack.isEnabled = !muteAudio
//            }
//        })
//        
//        CallKitManager.instance.onMicrophoneMuteAction = { [weak self] in
//            guard let self = self else {return}
//            self.audioEnabled.pressed = !self.audioEnabled.pressed
//        }
//        
//        toolbar.add(ButtonsFactory.decline(), action: { [weak self] sender in
//            self?.session?.hangUp(["hangup": "hang up"])
//        })
//        
//        toolbar.updateItems()
//        
//        let mask: UIView.AutoresizingMask = [.flexibleWidth,
//                                             .flexibleHeight,
//                                             .flexibleLeftMargin,
//                                             .flexibleRightMargin,
//                                             .flexibleTopMargin,
//                                             .flexibleBottomMargin]
//        
//        // stats view
//        statsView.frame = view.bounds
//        statsView.autoresizingMask = mask
//        statsView.isHidden = true
//        statsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateStatsState)))
//        view.addSubview(statsView)
//        
//        // add button to enable stats view
//        state = .connecting
//    }
//    
//    // MARK: - Actions
//    func startCall() {
//        //Begin play calling sound
//        beepTimer = Timer.scheduledTimer(timeInterval: QBRTCConfig.dialingTimeInterval(),
//                                         target: self,
//                                         selector: #selector(playCallingSound(_:)),
//                                         userInfo: nil, repeats: true)
//        playCallingSound(nil)
//        //Start call
//        let userInfo = ["name": "Test", "url": "http.quickblox.com", "param": "\"1,2,3,4\""]
//        
//        session?.startCall(userInfo)
//    }
//    
//    func acceptCall() {
//        SoundProvider.stopSound()
//        //Accept call
//        let userInfo = ["acceptCall": "userInfo"]
//        session?.acceptCall(userInfo)
//    }
//    
//    private func closeCall() {
//        
//        CallKitManager.instance.endCall(with: callUUID)
//        cameraCapture.stopSession(nil)
//        
//        let audioSession = QBRTCAudioSession.instance()
//        if audioSession.isInitialized == true,
//            audioSession.audioSessionIsActivatedOutside(AVAudioSession.sharedInstance()) == false {
//            debugPrint("[CallViewController] Deinitializing QBRTCAudioSession.")
//            audioSession.deinitialize()
//        }
//        
//        if let beepTimer = beepTimer {
//            beepTimer.invalidate()
//            self.beepTimer = nil
//            SoundProvider.stopSound()
//        }
//        
//        if let callTimer = callTimer {
//            callTimer.invalidate()
//            self.callTimer = nil
//        }
//        
//        toolbar.isUserInteractionEnabled = false
//        UIView.animate(withDuration: 0.5) {
//            self.toolbar.alpha = 0.4
//        }
//        state = .disconnected
//        title = "End - \(string(withTimeDuration: timeDuration))"
//    }
//    
//    @objc func updateStatsView() {
//        //shouldGetStats = !shouldGetStats
//        //statsView.isHidden = !statsView.isHidden
//    }
//    
//    @objc func updateStatsState() {
//        updateStatsView()
//    }
//    
//    
//}

import SwiftUI


//struct VideoCallingView: UIViewRepresentable {
//
//
////    func makeCoordinator() -> AppleSignUpCoordinator {
////        return AppleSignUpCoordinator(<#SignUpWithAppleView#>)
////    }
////
//    func makeUIView(context: Context) -> UIViewController {
//
//
//        return UsersViewController()
//    }
//
//    func updateUIView(_ uiView: UIViewController, context: Context) {
//    }
//}



