//
//  HistoryTableView.swift
//  FTAM
//
//  Created by Игорь Клевжиц on 04.02.2025.
//

import UIKit

class HistoryTableViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "История"
        element.textAlignment = .center
        element.font = .systemFont(ofSize: 24, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var historyTableView: UITableView = {
        let element = UITableView()
        element.dataSource = self
        element.delegate = self
        element.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private let spacing: CGFloat = 20
    var historyPrediction: [HistoryPredicrion] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
    }
}

private extension HistoryTableViewController {
    
    // MARK: - Set Views
    
    func setViews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(historyTableView)
    }
    
    // MARK: - Setup Constraints
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            
            historyTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            historyTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            historyTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}

// MARK: - Delegate and DataSourse for TableView

extension HistoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyPrediction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.reuseIdentifier,
            for: indexPath)
        as! HistoryTableViewCell
        
        let prediction = historyPrediction[indexPath.row]
        cell.configureCell(with: prediction)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

}
