import SwiftUI
import AVFoundation
import Speech

struct ContentView: View {
    @State private var isRecording = false
    @State private var recognizedText = ""
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioFileURL: URL?
    
    var body: some View {
        VStack {
            Text(recognizedText)
                .padding()
            
            Button(action: {
                if self.isRecording {
                    self.stopRecording()
                } else {
                    self.startRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            self.requestPermissions()
        }
    }
    
    // Request permissions for audio recording and speech recognition
    private func requestPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if !granted {
                print("Microphone permission not granted")
            }
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not authorized")
            @unknown default:
                fatalError("Unknown speech recognition authorization status")
            }
        }
    }
    
    // Start recording audio
    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let tempDir = NSTemporaryDirectory()
            let filePath = tempDir + "tempAudio.m4a"
            self.audioFileURL = URL(fileURLWithPath: filePath)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            self.audioRecorder = try AVAudioRecorder(url: self.audioFileURL!, settings: settings)
            self.audioRecorder?.record()
            self.isRecording = true
        } catch {
            print("Failed to set up audio recording: \(error.localizedDescription)")
        }
    }
    
    // Stop recording and process the audio file
    private func stopRecording() {
        self.audioRecorder?.stop()
        self.isRecording = false
        
        if let url = self.audioFileURL {
            transcribeAudio(url: url)
        }
    }
    
    // Transcribe the audio file
    private func transcribeAudio(url: URL) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)
        
        recognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
            } else if let error = error {
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
