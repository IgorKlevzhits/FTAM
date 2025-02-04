//
//  ViewController.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 03.02.2025.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - UI
    
    private lazy var requestSearchBar: UISearchBar = {
        let element = UISearchBar()
        element.searchTextField.font = .systemFont(ofSize: 20)
        element.placeholder = "Введите ваш запрос"
        element.searchBarStyle = .minimal
        element.delegate = self
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var predictionButton: UIButton = {
        let element = UIButton()
        element.layer.cornerRadius = 10
        element.tintColor = .white
        element.backgroundColor = .purple
        element.setTitle("ПОЛУЧИТЬ ПРЕДСКАЗАНИЕ", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 20)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private var memeOneImageView = UIImageView(nameImage: "backCard")
    private var memeTwoImageView = UIImageView(nameImage: "backCard")
    private var memeThreeImageView = UIImageView(nameImage: "backCard")
    
    private lazy var reactionButtonsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private var goodReactionButton = UIButton(color: .green, emoji: "👍")
    private var badReactionButton = UIButton(color: .red, emoji: "👎")
    
    // MARK: - Private Properties
    
    private let networkManager = NetworkManager.shared
    private let spacing: CGFloat = 20
    private let heightElements: CGFloat = 60
    private var isCardSelected = false
    
    // MARK: - Private Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            requestSearchBar.resignFirstResponder()
        
            predictionButtonTapped()
        }
    
    private func changeImage(link: String, imageView: UIImageView) {
            guard let url = URL(string: link) else { return }
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    
    @objc private func predictionButtonTapped() {
        requestSearchBar.resignFirstResponder()
        if requestSearchBar.text!.isEmpty || requestSearchBar.text!.count < 5 {
            showSelectCardAlert(message: "Недостаточно символов")
            return
        }
        if isCardSelected {
            showSelectCardAlert(message: "Не выбрана реакция")
            return
        }
        if memeOneImageView.transform == .identity && memeTwoImageView.transform == .identity && memeThreeImageView.transform == .identity {
            showSelectCardAlert(message: "Не выбрано предсказание")
        } else {
            requestSearchBar.isUserInteractionEnabled = false
            toggleImageViewPosition(memeOneImageView, delay: 0.2)
            toggleImageViewPosition(memeTwoImageView, delay: 0.4)
            toggleImageViewPosition(memeThreeImageView, delay: 0.6)
        }
    }
    
    private func showSelectCardAlert(message: String) {
        var alertController = UIAlertController()
        if message == "Не выбрано предсказание" {
            alertController = UIAlertController(title: "Выберите карту",
                                                    message: "Пожалуйста, выберите одну из карт, чтобы продолжить.",
                                                    preferredStyle: .alert)
        } else if message == "Не выбрана реакция" {
            alertController = UIAlertController(title: "Как вам предсказание?",
                                                    message: "Пожалуйста, выберите подходит ли вам предсказание, чтобы продолжить.",
                                                    preferredStyle: .alert)
        } else if message == "Недостаточно символов" {
            alertController = UIAlertController(title: "Нехватает данных о вашем запросе",
                                                    message: "Пожалуйста, сделайте ваш запрос более ёмким, чтобы продолжить.",
                                                    preferredStyle: .alert)
        }
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func toggleImageViewPosition(_ imageView: UIImageView, delay: TimeInterval) {
        if imageView.transform == .identity {
            UIView.animate(withDuration: 1, delay: delay, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            })
        } else {
            UIView.animate(withDuration: 1, delay: delay, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if isCardSelected {
            return
        } else {
            isCardSelected = true
            UIView.animate(withDuration: 1) {
                self.goodReactionButton.alpha = 1
                self.badReactionButton.alpha = 1
            }
        }
        guard let selectedImageView = sender.view as? UIImageView else { return }
        guard let mem = networkManager.memes.randomElement() else { return }

        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        
        UIView.animate(withDuration: 0.5, animations: {
            let centerX = screenWidth / 2
            let centerY = screenHeight / 2
            
            selectedImageView.transform = CGAffineTransform(translationX: centerX - selectedImageView.center.x,
                                                            y: centerY - selectedImageView.center.y)
            selectedImageView.transform = selectedImageView.transform.scaledBy(x: 1.5, y: 1.5)  // Увеличиваем изображение
        }) { _ in
            UIView.transition(with: selectedImageView, duration: 1.0, options: .transitionFlipFromLeft, animations: {
                self.changeImage(link: mem.url, imageView: selectedImageView)
            }, completion: nil)
        }
        
        if selectedImageView == memeOneImageView {
            animateOtherImagesToRight(except: memeOneImageView)
        } else if selectedImageView == memeTwoImageView {
            animateOtherImagesToRight(except: memeTwoImageView)
        } else {
            animateOtherImagesToRight(except: memeThreeImageView)
        }
    }
    
    private func animateOtherImagesToRight(except imageView: UIImageView) {
        if imageView != memeOneImageView {
            animateImageToRight(memeOneImageView)
        }
        if imageView != memeTwoImageView {
            animateImageToRight(memeTwoImageView)
        }
        if imageView != memeThreeImageView {
            animateImageToRight(memeThreeImageView)
        }
    }
    
    private func animateImageToRight(_ imageView: UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            imageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        })
    }
    
    @objc private func reactionButtonTapped(_ sender: UIButton) {
        requestSearchBar.isUserInteractionEnabled = true
        isCardSelected = false
        UIView.animate(withDuration: 1) {
            self.memeOneImageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.memeTwoImageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            self.memeThreeImageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        }
        memeOneImageView.image = UIImage(named: "backCard")
        memeTwoImageView.image = UIImage(named: "backCard")
        memeThreeImageView.image = UIImage(named: "backCard")
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = sender.backgroundColor
            self.goodReactionButton.alpha = 0
            self.badReactionButton.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = .white
            }
        }
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
        networkManager.fetchMemes()
    }

}

private extension ViewController {
    
    // MARK: - Set Views
    
    func setViews() {
        view.backgroundColor = .white
        view.addSubview(requestSearchBar)
        view.addSubview(predictionButton)
        
        view.addSubview(memeOneImageView)
        view.addSubview(memeTwoImageView)
        view.addSubview(memeThreeImageView)
        
        view.addSubview(reactionButtonsStackView)
        reactionButtonsStackView.addArrangedSubview(goodReactionButton)
        reactionButtonsStackView.addArrangedSubview(badReactionButton)
        
        memeOneImageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        memeTwoImageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        memeThreeImageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        goodReactionButton.alpha = 0
        badReactionButton.alpha = 0
        
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        memeOneImageView.isUserInteractionEnabled = true
        memeOneImageView.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        memeTwoImageView.isUserInteractionEnabled = true
        memeTwoImageView.addGestureRecognizer(tapTwo)
        
        let tapThree = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        memeThreeImageView.isUserInteractionEnabled = true
        memeThreeImageView.addGestureRecognizer(tapThree)
        
        predictionButton.addTarget(self, action: #selector(predictionButtonTapped), for: .touchUpInside)
        requestSearchBar.searchTextField.addTarget(self, action: #selector(predictionButtonTapped), for: .touchUpInside)
        
        goodReactionButton.addTarget(self, action: #selector(reactionButtonTapped), for: .touchUpInside)
        badReactionButton.addTarget(self, action: #selector(reactionButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Constraints
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            requestSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            requestSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            requestSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            requestSearchBar.heightAnchor.constraint(equalToConstant: heightElements),
            
            predictionButton.topAnchor.constraint(equalTo: requestSearchBar.bottomAnchor, constant: spacing),
            predictionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            predictionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            predictionButton.heightAnchor.constraint(equalToConstant: heightElements),
            
            memeOneImageView.topAnchor.constraint(equalTo: predictionButton.bottomAnchor, constant: spacing),
            memeOneImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            memeOneImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            memeOneImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.18),
            
            memeTwoImageView.topAnchor.constraint(equalTo: memeOneImageView.bottomAnchor, constant: spacing),
            memeTwoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            memeTwoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            memeTwoImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.18),
            
            memeThreeImageView.topAnchor.constraint(equalTo: memeTwoImageView.bottomAnchor, constant: spacing),
            memeThreeImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            memeThreeImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            memeThreeImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.18),
            
            reactionButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            reactionButtonsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            goodReactionButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            goodReactionButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            
            badReactionButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
            badReactionButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
        ])
    }
}
