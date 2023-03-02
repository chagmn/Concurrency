//
//  ViewController.swift
//  Concurrency
//
//  Created by ChangMin on 2023/03/02.
//

import UIKit

final class ViewController: UIViewController {
    private let repository = ImageRepository()
    
    // MARK: UI Componets
    private lazy var imageTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = ImageDownloadCell.height
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(ImageDownloadCell.self,
                           forCellReuseIdentifier: ImageDownloadCell.identifier)
        return tableView
    }()
    
    private lazy var allLoadButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Load All Images", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(clickAllLoadButton), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViewLayout()
    }
}

// MARK: - Private Functions
extension ViewController {
    private func setupViewLayout() {
        [imageTableView, allLoadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageTableView.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        NSLayoutConstraint.activate([
            allLoadButton.topAnchor.constraint(equalTo: imageTableView.bottomAnchor, constant: 16),
            allLoadButton.leadingAnchor.constraint(equalTo: imageTableView.leadingAnchor),
            allLoadButton.trailingAnchor.constraint(equalTo: imageTableView.trailingAnchor),
            allLoadButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @objc private func clickAllLoadButton(_ sender: UIButton) {
        let cellCount = imageTableView.numberOfRows(inSection: 0)
        
        for i in 0..<cellCount {
            guard let cell = imageTableView.cellForRow(at: IndexPath(row: i, section: 0))
                    as? ImageDownloadCell else { return }
            cell.downloadImage()
        }
    }
}

// MARK: - TableView Delegate, DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 5
    }
        
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageDownloadCell.identifier,
            for: indexPath
        ) as? ImageDownloadCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
}
