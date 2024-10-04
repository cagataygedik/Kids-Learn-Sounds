//
//  KLSOnboardingViewController.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 3.10.2024.
//

import UIKit
import SnapKit
import Lottie

final class KLSOnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let lottieAnimations = ["AnimalsAnimation", "PenguinMusic"]
    private let pageLabels = ["Welcome to Kids Learn Sounds. We're here to help you learn hundreds of sounds in the world.", "Come and join us and explore the world of sounds."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.mainBackgroundColor
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0..<lottieAnimations.count {
            let pageView = createOnboardingPage(with: lottieAnimations[i], labelText: pageLabels[i], index: i)
            scrollView.addSubview(pageView)
        }
        view.addSubview(pageControl)
        pageControl.numberOfPages = lottieAnimations.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
    }
    
    private func createOnboardingPage(with animationName: String, labelText: String, index: Int) -> UIView {
        let pageView = UIView()
        let animationView = LottieAnimationView(name: animationName)
        let nextButton = KLSButton(backgroundColor: Constants.mainAppColor!, title: "Continue")
        let label = UILabel()
        
        scrollView.addSubview(pageView)
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        label.text = labelText
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        
        pageView.addSubview(animationView)
        pageView.addSubview(label)
        pageView.addSubview(nextButton)
        
        pageView.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(view)
            make.left.equalTo(scrollView).offset(view.frame.width * CGFloat(index))
            make.top.bottom.equalTo(scrollView)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(pageView)
            make.left.right.equalTo(pageView)
            make.height.equalTo(view.frame.height * 0.6) // Adjust height proportion as needed
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(10)
            make.left.right.equalTo(pageView).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageView.safeAreaLayoutGuide.snp.bottom).offset(-40) // Pin to bottom with some padding
            make.centerX.equalTo(pageView)
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
        
        return pageView
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-50)
            make.centerX.equalTo(view)
        }
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        let currentPage = pageControl.currentPage
        let nextPage = min(currentPage + 1, lottieAnimations.count - 1)
        
        if currentPage == lottieAnimations.count - 1 {
            // Last page - Navigate to the main app
            navigateToMainApp()
        } else {
            // Move to the next page
            let offset = CGPoint(x: view.frame.width * CGFloat(nextPage), y: 0)
            scrollView.setContentOffset(offset, animated: true)
            pageControl.currentPage = nextPage
        }
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let offset = CGPoint(x: view.frame.width * CGFloat(sender.currentPage), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    private func navigateToMainApp() {
        let mainAppViewController = KLSTabBarController()
        
        // Ensure that you do NOT wrap KLSTabBarController inside another UINavigationController
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            
            if let window = windowScene.windows.first {
                window.rootViewController = mainAppViewController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}
