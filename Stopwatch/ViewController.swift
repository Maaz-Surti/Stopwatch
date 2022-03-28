//
//  ViewController.swift
//  Stopwatch
//
//  Created by TechnoMac6 on 18/01/22.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnStartStop: UIButton!
    
    var timerCounting: Bool = false
    var startTime: Date?
    var stopTime: Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingTime"
    
    var scheduledTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    func prepareUI(){
        
        // setting BG image
        if let image = UIImage(named: "img"){
            self.view.backgroundColor = UIColor(patternImage: image)
        } else {
            print("blelele")
        }
        
        // image blur
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        
        // display corner radius
        lblTime.layer.masksToBounds = true
        lblTime.layer.cornerRadius = 10
        
        
//        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
//        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        if timerCounting{
            startTimer()
        } else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                     let time = calcRestartTime(start: start, stop: stop)
                     let diff = Date().timeIntervalSince(time)
                     setTimeLabel(Int(diff))
                }
            }
        }
        
    }
    @IBAction func btnStartStop(_ sender: UIButton) {
            
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        }else{
              if let stop = stopTime {
                  let restartTime = calcRestartTime(start: startTime!, stop: stop)
                  setStopTime(date: nil)
                  setStartTime(date: restartTime)
              } else {
                  setStartTime(date: Date())
              }
            
              startTimer()
           }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer(){
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        btnStartStop.setTitle("Stop", for: .normal)
        btnStartStop.setTitleColor(.red, for: .normal)
        
    }
    
    func stopTimer(){
        
        scheduledTimer.invalidate()
        setTimerCounting(false)
        btnStartStop.setTitle("Start", for: .normal)
        btnStartStop.setTitleColor(.black, for: .normal)
    }
    
    @objc func refreshValue(){
        
        if let start = startTime{
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        } else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int){
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        lblTime.text = timeString
    }
   
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int){
        print(seconds)
        let hour = seconds/3600
        let min = (seconds % 3600) / 60
        let sec = (seconds % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    @IBAction func btnReset(_ sender: Any) {
        
        setStopTime(date: nil)
        setStartTime(date: nil)
        lblTime.text = makeTimeString(hour: 0, min: 0, sec: 0)
        stopTimer()
        
        btnStartStop.setTitle("Start", for: .normal)
        btnStartStop.setTitleColor(.black, for: .normal)
    }
    
    func setStartTime(date: Date?){
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?){
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val : Bool){
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
}
