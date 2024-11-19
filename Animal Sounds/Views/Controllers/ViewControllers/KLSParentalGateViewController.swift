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
    
    private let containerView = KLSPopUpContainerView()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let parentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.tintColor = Constants.mainAppColor
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let submitButton = KLSButton(backgroundColor: Constants.mainAppColor!, title: NSLocalizedString("submit", comment: "Submit button title"))
    
    private var correctAnswer: Int?
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    var onGateSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureContainerView()
        configureUI()
        generateQuestion()
        playVoiceOverPrompt()
    }
    
    private func configureViewController() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        parentLabel.text = NSLocalizedString("ask_your_presents", comment: "Prompt for the parental gate")
    }
    
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(330)
            make.height.equalTo(260)
        }
    }
    
    private func configureUI() {
        configureDismissButton()
        configureParentLabel()
        configureQuestionLabel()
        configureAnswerTextField()
        configureSubmitButton()
    }
    
    private func configureDismissButton() {
        containerView.addSubview(dismissButton)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(8)
            make.trailing.equalTo(containerView.snp.trailing).offset(-8)
            make.width.height.equalTo(28)
        }
    }
    
    private func configureParentLabel() {
        containerView.addSubview(parentLabel)
        parentLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
    }
    
    private func configureQuestionLabel() {
        containerView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(parentLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
    }
    
    private func configureAnswerTextField() {
        containerView.addSubview(answerTextField)
        answerTextField.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
            make.width.equalTo(100)
        }
    }
    
    private func configureSubmitButton() {
        containerView.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(answerTextField.snp.bottom).offset(20)
            make.centerX.equalTo(containerView)
            make.height.equalTo(44)
            make.width.equalTo(300)
        }
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    private func generateQuestion() {
        let number1 = Int.random(in: 1...10)
        let number2 = Int.random(in: 1...10)
        questionLabel.text = "What is \(number1) + \(number2)?"
        correctAnswer = number1 + number2
    }
    
    private func playVoiceOverPrompt() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let currentLocale = Locale.current
            let prompt = NSLocalizedString("ask_your_presents", comment: "Prompt for the parental gate")
            let utterance = AVSpeechUtterance(string: prompt)
            
            if currentLocale.languageCode == "en" {
                utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-compact")
            } else if let voice = AVSpeechSynthesisVoice(language: currentLocale.identifier) {
                utterance.voice = voice
            } else {
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            }
            
            speechSynthesizer.speak(utterance)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    @objc private func checkAnswer() {
        guard let userAnswer = Int(answerTextField.text ?? ""),
              userAnswer == correctAnswer else {
            showIncorrectAlert()
            return
        }
        dismiss(animated: true)
        onGateSuccess?()
    }
    
    private func showIncorrectAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("incorrect", comment: "Incorrect answer title"),
            message: NSLocalizedString("try_again_or_ask_parent", comment: "Try again message"),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("ok", comment: "OK button title"),
            style: .default
        ))
        present(alert, animated: true)
    }
}
