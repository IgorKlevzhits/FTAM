//
//  HistoryTableViewCell.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 04.02.2025.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private lazy var memImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 20
        element.clipsToBounds = true
        element.layer.borderWidth = 5
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var requestLabel: UILabel = {
        let element = UILabel()
        element.numberOfLines = 0
        element.font = .systemFont(ofSize: 18, weight: .medium)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private let spacing: CGFloat = 10
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with prediction: HistoryPredicrion) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: prediction.url) {
                DispatchQueue.main.async {
                    self.memImageView.image = UIImage(data: data)
                }
            }
        }
        requestLabel.text = "Запрос: \(prediction.request)"
    }
    
    private func setupLayout() {
        
        contentView.addSubview(memImageView)
        contentView.addSubview(requestLabel)
        
        NSLayoutConstraint.activate([
            memImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            memImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            memImageView.widthAnchor.constraint(equalTo: memImageView.heightAnchor),
            
            requestLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            requestLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            requestLabel.trailingAnchor.constraint(equalTo: memImageView.trailingAnchor, constant: -spacing),
            requestLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])
        
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
