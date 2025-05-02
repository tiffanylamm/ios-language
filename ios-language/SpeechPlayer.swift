//
//  SpeechPlayer.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//

//import AVFoundation
//
//class SpeechPlayer: ObservableObject {
//    private let synthesizer = AVSpeechSynthesizer()
//
//    func play(vocabPairs: [VocabPair]) {
//        // If it's paused, resume instead of restarting
//        if synthesizer.isPaused {
//            synthesizer.continueSpeaking()
//            return
//        }
//
//        // If it's currently speaking, stop it and restart
//        if synthesizer.isSpeaking {
//            synthesizer.stopSpeaking(at: .immediate)
//        }
//
//        // Speak each vocab pair
//        for pair in vocabPairs {
//            let en = AVSpeechUtterance(string: pair.word)
//            en.voice = AVSpeechSynthesisVoice(language: "en-US")
//            en.postUtteranceDelay = 0.5
//            synthesizer.speak(en)
//
//            let vi = AVSpeechUtterance(string: pair.translated_word)
//            vi.voice = AVSpeechSynthesisVoice(language: "vi-VN")
//            vi.postUtteranceDelay = 1.0
//            synthesizer.speak(vi)
//        }
//    }
//
//    func pause() {
//        if synthesizer.isSpeaking {
//            synthesizer.pauseSpeaking(at: .immediate)
//        }
//    }
//
//    func resume() {
//        if synthesizer.isPaused {
//            synthesizer.continueSpeaking()
//        }
//    }
//
//    func stop() {
//        synthesizer.stopSpeaking(at: .immediate)
//    }
//}

import AVFoundation

@MainActor
class SpeechPlayer: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var currentSpokenWord: String = ""
    private var isCancelled = false

    func play(vocabPairs: [VocabPair], firstLang: String, secondLang: String) {
        isCancelled = false

        Task {
            for pair in vocabPairs {
                guard !isCancelled else { break }

                currentSpokenWord = pair.word
                speak(pair.word, lang: firstLang)
                try? await Task.sleep(nanoseconds: 2_000_000_000)

                guard !isCancelled else { break }

                currentSpokenWord = pair.translated_word
                speak(pair.translated_word, lang: secondLang)
                try? await Task.sleep(nanoseconds: 2_500_000_000)
            }

            currentSpokenWord = ""
        }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isCancelled = true
        currentSpokenWord = ""
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }

    func resume() {
        synthesizer.continueSpeaking()
    }

    private func speak(_ text: String, lang: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        synthesizer.speak(utterance)
    }
}






