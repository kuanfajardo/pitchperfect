//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Juan Diego Fajardo on 5/25/16.
//  Copyright © 2016 Juan Diego Fajardo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HELLO")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func recordAudio(sender: AnyObject) {
        // Debug
        print("Record button pressed")
        
        // UI Changes
        recordingLabel.text = "Recording in progress"
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        
        // Record Audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        // Debug
        
        // UI Changes
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        recordingLabel.text = "Tap to Record"
        
        // Stop Recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        print("stop recording button pressed")

    }
    
    
    // MARK: Navigation
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppearCalled")
        stopRecordingButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("audio recording finished")
        print(flag)
        if (flag) {
            self.performSegueWithIdentifier("stopRecordingSegue", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    
}

