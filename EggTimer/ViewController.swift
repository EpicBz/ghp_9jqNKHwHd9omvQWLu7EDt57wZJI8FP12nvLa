//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//
// updated by bryan Sands 04/14/2022
// enhancements
// Second counter along side the progress bar to tell time for much longer cooking time
// Changes the color of the DONE! to red when finshed
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressTimer: UILabel!
    
    let eggTimes = ["Soft": 3, "Medium": 420, "Hard": 540]
    var timer = Timer()
    let red = UIColor.red
    let black = UIColor.black
    let textFinshed = "DONE!"
    let textSoft = "Soft"
    var player: AVAudioPlayer!
    var totalTime = 0
    var secondsPassed = 0
    
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        // Returns color of text type to black
        let attrsString = NSMutableAttributedString(string:titleLabel.text!)
        let range = (titleLabel.text! as NSString).range(of:textSoft)
        if (range.length > 0) {
             attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:black,range:range)
        }
        titleLabel.attributedText = attrsString

        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness

        timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    }
    
    @objc func updateTimer() {
        //progressTimer is the second timer counting down to zero
        if secondsPassed < totalTime {
            progressTimer.text = String(totalTime)
            secondsPassed += 1
            progressBar.progress = Float(secondsPassed) / Float(totalTime)
            progressTimer.text = String(totalTime - secondsPassed)
            print(Float(secondsPassed) / Float(totalTime))
            
        } else {
            timer.invalidate()
            progressTimer.text = ""
            titleLabel.text = "DONE!"
            
            //changes text time to red
            let attrsString = NSMutableAttributedString(string:titleLabel.text!)
            let range = (titleLabel.text! as NSString).range(of: textFinshed)
            if (range.length > 0) {
                 attrsString.addAttribute(NSAttributedString.Key.foregroundColor,value:red,range:range)
            }
            titleLabel.attributedText = attrsString
            
            
            let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        }
    }
    
}
