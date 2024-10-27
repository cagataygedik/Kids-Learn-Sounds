//
//  KLSParentalGateViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 27.10.2024.
//

import UIKit
import AVFoundation
import SnapKit

final class KLSParentalGateViewController: UIViewController {

    private let parentLabel = UILabel()
    private let questionLabel = UILabel()
    private let answerTextField = UITextField()
    private let submitButton = UIButton(type: .system)
    private var correctAnswer: Int?
    private var speechSynthesizer = AVSpeechSynthesizer()
    var onGateSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        generateQuestion()
        playVoiceOverPrompt()
    }

    private func setupViews() {
        parentLabel.text = NSLocalizedString("ask_your_presents", comment: "Prompt for the parental gate")
        parentLabel.font = .systemFont(ofSize: 14, weight: .bold)
        parentLabel.textAlignment = .center
        parentLabel.textColor = .black
        parentLabel.numberOfLines = 0
        view.addSubview(parentLabel)
        parentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        questionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(parentLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        // Configure answer text field
        answerTextField.borderStyle = .roundedRect
        answerTextField.keyboardType = .numberPad
        answerTextField.textAlignment = .center
        answerTextField.font = .systemFont(ofSize: 20)
        view.addSubview(answerTextField)
        answerTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.width.equalTo(100)
        }

        // Configure submit button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(answerTextField.snp.bottom).offset(20)
        }
    }

    private func generateQuestion() {
        // Simple math question generation
        let number1 = Int.random(in: 1...10)
        let number2 = Int.random(in: 1...10)
        questionLabel.text = "What is \(number1) + \(number2)?"
        questionLabel.textColor = .black
        correctAnswer = number1 + number2
    }

    @objc private func checkAnswer() {
        guard let userAnswer = Int(answerTextField.text ?? ""), userAnswer == correctAnswer else {
            showIncorrectAlert()
            return
        }
        dismiss(animated: true)
        onGateSuccess?()
        
    }

    private func showIncorrectAlert() {
        let alert = UIAlertController(title: "Incorrect", message: "Please try again or ask a parent.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func playVoiceOverPrompt() {
        
        let currentLocale = Locale.current
        let prompt = NSLocalizedString("ask_your_presents", comment: "Prompt for the parental gate")
        let utterance = AVSpeechUtterance(string: prompt)
        
        if let voice = AVSpeechSynthesisVoice(language: currentLocale.identifier) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        // Speak the utterance
        speechSynthesizer.speak(utterance)
    }
}

