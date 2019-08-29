//
//  CameraViewController.swift
//  TemanNetraProgram
//
//  Created by Georgius Yoga Dewantama on 20/08/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Vision
import CoreMotion

let synthesizer = AVSpeechSynthesizer()
var stopRecognition = false

class CameraViewController: UIViewController {

    var counter = 0
    var cameraDevice: AVCaptureDevice?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonCapture: UIButton!
    
    var motionManager = CMMotionManager()
    
    var session = AVCaptureSession()
    var tidakYakin = 0
    var requests = [VNRequest]()
    var spokenText: String = ""
    var titikTengahDeviceX: Float = 0
    var titikTengahDeviceY: Float = 0
    var recognizedTextSize: Float = 0
    var posisiSudahPas = false
    var avgConfidence: Float = 0
    var totalConfidence: Float = 0
    var observationCounter: Float = 0
    var titikTengahTextX: Float = 0
    var titikTengahTextY: Float = 0
    var koordinatTextTerdekatX: Float = 9999
    var koordinatTextTerdekatY: Float = 9999
    var recognizedText: String = ""
    var atas = false
    var bawah = false
    var kiri = false
    var kanan = false
    var sudahTahan = 1
    var spokenTextSize: Float = 0
    var voiceOverCondition = UIAccessibility.isVoiceOverRunning
    var lagiSave = false
//    var isAnnouncementFinished = true
//    var isDelayed = true
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if voiceOverCondition == true {
            print("voice over nyala")
        }
        else {
            buttonCapture.removeFromSuperview()
            print("voice over mati")
        }
        stopRecognition = false
        print("INI camera VIEW CONTROLLER")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopRecognition = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageView.frame.size)
        stopRecognition = true
        startLiveVideo()
        startTextRecognition()
        degreeDetection()
        titikTengahDeviceX = Float(imageView.frame.width/2)
        titikTengahDeviceY = Float(imageView.frame.height/2)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.announcementFinished(notification:)), name: UIAccessibility.announcementDidFinishNotification, object: nil)
        //print("TitikX: ", titikTengahDeviceX)
        //print("TitikY: ", titikTengahDeviceY)
        
        //func segue swipe
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        
       // leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        
       // self.view.addGestureRecognizer(leftSwipe)
        
        //startTextDetection()
        // Do any additional setup after loading the view.
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        //double  tap
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired  = 2
//        self.imageView.addGestureRecognizer(tap)
    }
    
    func degreeDetection() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.05
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
                
                let angle = self.degrees(radians: (data?.attitude.roll)!)
                if angle > 150 || angle < -150 {
                    synthesizer.stopSpeaking(at: .immediate)
                    //print("omongan berhenti")
                }
            }
        }
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
//    @objc private func announcementFinished(notification: Notification) {
//        print("announcement selesai")
//        let announcementIsFinished = notification.userInfo?.values.reversed().first
//        if announcementIsFinished as? Int == 1
//        {
//            isAnnouncementFinished = true
//        }
//        else
//        {
//            isAnnouncementFinished = false
//        }
//    }
    
        override func becomeFirstResponder() -> Bool {
            return true
        }
        
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                synthesizer.stopSpeaking(at: .immediate)
                //UIAccessibility.post(notification: .announcement, argument: "berhenti")
            }
        }
    
    @IBAction func panduanButtonTapped(_ sender: Any) {
        synthesizer.stopSpeaking(at: .immediate)
        let speechUtterance = AVSpeechUtterance(string: "Arahkan kamera ke media cetak yang ingin anda baca. Ikuti arahan untuk memastikan tulisan tersebut dapat dibaca oleh aplikasi. Guncangkan ponsel untuk berhenti membaca dan memindai ulang tulisan. Ketuk layar ponsel dua kali untuk menyimpan tulisan ke dalam arsip. Buka arsip untuk membaca ulang catatan yang telah anda simpan.")
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
        synthesizer.speak(speechUtterance)
    }
    
    
        func startLiveVideo() {
            cameraView.session = session
            
            let cameraDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            for device in cameraDevices.devices {
                if device.position == .back {
                    cameraDevice = device
                    break
                }
            }
            
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: cameraDevice!)
                if session.canAddInput(captureDeviceInput) {
                    session.addInput(captureDeviceInput)
                }
            }
            catch {
                print("Error occured \(error)")
                return
            }
            session.sessionPreset = .high
            let videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Buffer Queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil))
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
            }
            cameraView.videoPreviewLayer.videoGravity = .resize
            session.startRunning()
        }
    
    private var cameraView: CameraView{
        return  imageView as! CameraView
    }
    
    func startTextRecognition(){
            let textRequest = VNRecognizeTextRequest(completionHandler: self.recognizeTextHandler)
            textRequest.usesLanguageCorrection = false
        textRequest.usesLanguageCorrection = false
            self.requests = [textRequest]
        }
        
        func recognizeTextHandler(request: VNRequest, error: Error?){
            if(synthesizer.isSpeaking == false && stopRecognition == false && lagiSave == false)
            {
                guard let observations = request.results as? [VNRecognizedTextObservation] else {print("no result"); return}

                DispatchQueue.main.async()
                {
                    //self.isAnnouncementFinished = false
                    self.avgConfidence = 0
                    self.totalConfidence = 0
                    self.observationCounter = 0
                    self.titikTengahTextX = 0
                    self.titikTengahTextY = 0
                    self.koordinatTextTerdekatX = 9999
                    self.koordinatTextTerdekatY = 9999
                    self.recognizedText = ""
                    self.atas = false
                    self.bawah = false
                    self.kiri = false
                    self.kanan = false
                    self.recognizedTextSize = 12
                    self.spokenTextSize = 12
                    self.imageView.layer.sublayers?.removeSubrange(1...)
                    for observation in observations
                    {
                        let penampungTitikTengahText = self.highlightWord(char: observation)
                    
                        self.titikTengahTextX = Float(penampungTitikTengahText.x)
                        self.titikTengahTextY = Float(penampungTitikTengahText.y)
                        //print("X :", self.titikTengahTextX)
                        //print("Y :", self.titikTengahTextY)
                        if(self.titikTengahTextX < self.titikTengahDeviceX && self.titikTengahDeviceX - self.titikTengahTextX < self.koordinatTextTerdekatX)
                        {
                            self.koordinatTextTerdekatX = self.titikTengahDeviceX - self.titikTengahTextX
                            self.kiri = true
                            self.kanan = false
                            self.spokenTextSize = self.recognizedTextSize
                            //self.spokenText = observation.topCandidates(1).first!.string
                            //print("perlu ke kiri")
                        }
                        else if(self.titikTengahTextX > self.titikTengahDeviceX && self.titikTengahTextX - self.titikTengahDeviceX < self.koordinatTextTerdekatX)
                        {
                            self.koordinatTextTerdekatX = self.titikTengahTextX - self.titikTengahDeviceX
                            self.kiri = false
                            self.kanan = true
                            self.spokenTextSize = self.recognizedTextSize
                            //self.spokenText = observation.topCandidates(1).first!.string
                            //print("perlu ke kanan")
                        }
                        
                        if(self.titikTengahTextY < self.titikTengahDeviceY && self.titikTengahDeviceY - self.titikTengahTextY < self.koordinatTextTerdekatY)
                        {
                            self.koordinatTextTerdekatY = self.titikTengahDeviceY - self.titikTengahTextY
                            self.atas = true
                            self.bawah = false
                            self.spokenTextSize = self.recognizedTextSize
                            //self.spokenText = observation.topCandidates(1).first!.string
                            //print("perlu ke atas")
                        }
                        else if(self.titikTengahTextY > self.titikTengahDeviceY && self.titikTengahTextY - self.titikTengahDeviceY < self.koordinatTextTerdekatY)
                        {
                            self.koordinatTextTerdekatY = self.titikTengahTextY - self.titikTengahDeviceY
                            self.atas = false
                            self.bawah = true
                            self.spokenTextSize = self.recognizedTextSize
                            //self.spokenText = observation.topCandidates(1).first!.string
                            //print("perlu ke bawah")
                        }
                        
                        //print("Koordinat terdekat X: ", self.koordinatTextTerdekatX)
                        //print("Koordinat terdekat Y: ", self.koordinatTextTerdekatY)
                        if(self.recognizedTextSize > 5)
                        {
                            guard let candidate = observation.topCandidates(1).first else {continue}
                            self.totalConfidence += candidate.confidence
                            self.observationCounter += 1
                            self.recognizedText += candidate.string + " "
                            //print(candidate.confidence)
                        }
                    }
                    //print("Ukuran text: ", self.spokenTextSize, self.spokenText)
                    if(self.spokenTextSize < 5)
                    {
                        
                        let speechUtterance = AVSpeechUtterance(string: "Mendekat")
                        speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                        synthesizer.speak(speechUtterance)
//                        UIAccessibility.post(notification: .announcement, argument: "Mendekat")
                        self.sudahTahan = 1
                    }
                    else if(self.koordinatTextTerdekatX > self.koordinatTextTerdekatY && self.koordinatTextTerdekatX > 50)
                    {
                        if(self.kiri == true)
                        {
                            let speechUtterance = AVSpeechUtterance(string: "Kiri")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: "Kiri")
                            self.sudahTahan = 1
                        }
                        else if(self.kanan == true)
                        {
                            let speechUtterance = AVSpeechUtterance(string: "Kanan")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: "Kanan")
                            
                            self.sudahTahan = 1
                        }
                    }
                    else if(self.koordinatTextTerdekatY > 50)
                    {
                        if(self.atas == true)
                        {
                            let speechUtterance = AVSpeechUtterance(string: "Atas")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: "Atas")
                            self.sudahTahan = 1
                        }
                        else if(self.bawah == true)
                        {
                            let speechUtterance = AVSpeechUtterance(string: "Bawah")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: "Bawah")
                            self.sudahTahan = 1
                        }
                    }
                    
                    if(self.koordinatTextTerdekatX < 50 && self.koordinatTextTerdekatY < 50 && self.spokenTextSize >= 5)
                    {
                        self.posisiSudahPas = true
//                        if(self.sudahTahan == 1)
//                        {
                              synthesizer.stopSpeaking(at: .immediate)
                            let speechUtterance = AVSpeechUtterance(string: "Tahan")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: "Tahan")
                            self.sudahTahan += 1
                        //}
                        //print("Posisi sudah pas")
                    }
                    else
                    {
                        self.posisiSudahPas = false
                        self.sudahTahan = 1
                        //print("Belum pas")
                    }
                    if(self.posisiSudahPas == true)
                    {
                        self.avgConfidence = self.totalConfidence/self.observationCounter
                        if(self.avgConfidence >= 0.40)
                        {
                            self.counter+=5
                        }
                        else
                        {
                            self.tidakYakin += 5
                        }
                        if(self.avgConfidence >= 0.40 && self.counter > 20)
                        {
                            self.recognizedText.removeLast()
                            synthesizer.stopSpeaking(at: .immediate)
                            let speechUtterance = AVSpeechUtterance(string: "\(self.recognizedText)")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
//                            UIAccessibility.post(notification: .announcement, argument: self.recognizedText)
                            self.counter = 0
                            self.tidakYakin = 0
                            self.sudahTahan = 1
                            self.spokenText = self.recognizedText
                            print(self.recognizedText,self.avgConfidence)
                        }
                        else if(self.tidakYakin >= 25)
                        {
                            self.counter = 0
                            self.tidakYakin = 0
                            synthesizer.stopSpeaking(at: .immediate)
                            let speechUtterance = AVSpeechUtterance(string: "Maaf, Saya tidak bisa mengenali tulisan ini")
                            speechUtterance.voice = AVSpeechSynthesisVoice(language: "id")
                            synthesizer.speak(speechUtterance)
                        }
                    }
                }
            }
        }
    
    
    func highlightWord(char: VNRecognizedTextObservation) -> CGPoint {
        
        var maxX: CGFloat = 999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 999.0
        var minY: CGFloat = 0.0

        if char.bottomLeft.x < maxX {
            maxX = char.bottomLeft.x
        }
        if char.bottomRight.x > minX {
            minX = char.bottomRight.x
        }
        if char.bottomRight.y < maxY {
            maxY = char.bottomRight.y
        }
        if char.topRight.y > minY {
            minY = char.topRight.y
        }
        
        let myWidth = imageView.frame.size.width
        let myHeight = imageView.frame.size.height
        let xCord = maxX * myWidth
        let yCord = (1 - minY) * myHeight
        let midX = (xCord + minX * myWidth) / 2
        let midY = (yCord + (1 - maxY) * myHeight) / 2
        recognizedTextSize = Float((1 - maxY) * myHeight - yCord)
        //print("Ukuran Text: ", recognizedTextSize)
        
        return CGPoint(x: midX, y: midY)
    }
    
        
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
   //func untuk segue swipe
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
                
        performSegue(withIdentifier: "goRight", sender: self)
                
    }
    
    @IBAction func buttonAlertSave(_ sender: Any) {
        
        lagiSave = true
        synthesizer.stopSpeaking(at: .immediate)
        let alert = UIAlertController(title: "Judul Catatan", message: "Berikan judul untuk menyimpan catatan ini ke dalam Arsip", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: { action in
            if let catatan  = alert.textFields?.first?.text {
                print("ok")
                self.saveData(judul: catatan, isi: self.spokenText)
            }
        }))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Buat judul catatanmu"
            self.lagiSave = true
        })
        
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: { action in
            self.lagiSave = false
        }))
        self.present(alert, animated: true)
    }
    
    @objc func doubleTapped() {
        lagiSave = true
        synthesizer.stopSpeaking(at: .immediate)
        let alert = UIAlertController(title: "Judul Catatan", message: "Berikan judul untuk menyimpan catatan ini ke dalam Arsip", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: { action in
            if let catatan  = alert.textFields?.first?.text {
                print("Judulnya: ", catatan)
                self.saveData(judul: catatan, isi: self.spokenText)
                //saveData(alert.textFields)
            }
        }))
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Buat judul catatanmu"
            self.lagiSave = true
        })

        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: { action in
            self.lagiSave = false
        }))
        self.present(alert, animated: true)
        
        
        
    }
    
    
    func saveData(judul: String, isi: String){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let note = Note(context: managedContext)
        
        note.judulNotes = judul
        note.isiNotes = isi
        note.timestampNotes = 27082019
        
        do {
            try managedContext.save()
            print("Berhasil menyimpan")
            self.lagiSave = false
        } catch  {
            print("Gagal menyimpan")
        }
    }
    
    
    
    
}




