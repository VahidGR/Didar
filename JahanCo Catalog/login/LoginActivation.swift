//
//  LoginActivation.swift
//  JahanCo Catalog
//
//  Created by Vahid Ghanbarpour on 8/12/17.
//  Copyright © 2017 Vahid Ghanbarpour. All rights reserved.
//

import UIKit

class LoginActivation: UIViewController {

    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var sendAgainButton: UIButton!
    
    var seconds = 120
    var timer = Timer()
    var isTimerRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        runTimer()
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        sendAgainButton.addTarget(self, action: #selector(sendAgainPressed), for: .touchUpInside)
    }
    
    @objc func donePressed() {
        self.performSegue(withIdentifier: "loggedIn", sender: self)
    }

    @objc func sendAgainPressed() {
        timer.invalidate()
        seconds = 120
        timerLabel.text = timeString(time: TimeInterval(seconds))
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }

    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
