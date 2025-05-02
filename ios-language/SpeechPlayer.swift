//
//  SpeechPlayer.swift
//  ios-language
//

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

    private func speak(_ text: String, lang: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        synthesizer.speak(utterance)
    }
}






