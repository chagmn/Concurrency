//
//  ImageDownloadCell.swift
//  Concurrency
//
//  Created by ChangMin on 2023/03/02.
//

import UIKit

final class ImageDownloadCell: UITableViewCell {
    // MARK: Properties
    static let identifier = String(describing: ImageDownloadCell.self)
    static let height = CGFloat(120)
    private let repository = ImageRepository()
    private var observation: NSKeyValueObservation!
    
    // MARK: UI Components
    private lazy var photoView: UIImageView = {
        return UIImageView(image: UIImage(systemName: "photo"))
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = .lightGray
        return view
    }()
    
    private lazy var loadButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .systemBlue
        button.setTitle("Load", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(clickLoadButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewLayout()
    }
    
    deinit {
        observation.invalidate()
        observation = nil
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Private Functions
extension ImageDownloadCell {
    private func setupViewLayout() {
        [photoView, progressView, loadButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            photoView.widthAnchor.constraint(equalToConstant: 120),
            photoView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 8),
            progressView.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])
        
        NSLayoutConstraint.activate([
            loadButton.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 8),
            loadButton.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            loadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            loadButton.heightAnchor.constraint(equalToConstant: 36),
            loadButton.widthAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    @objc private func clickLoadButton(_ sender: UIButton) {
        repository.fetchImage { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoView.image = image
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        downloadImage()
    }
}
// MARK: - Functions
extension ImageDownloadCell {
    func downloadImage() {
        repository.fetchImage { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoView.image = image
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        observation = repository.task?.progress.observe(
            \.fractionCompleted,
             options: .new,
             changeHandler: { task, change in
                 DispatchQueue.main.async {
                     self.progressView.progress = Float(task.fractionCompleted)
                 }
        })
    }
}
