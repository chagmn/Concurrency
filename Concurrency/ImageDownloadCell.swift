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
//    private var observation: NSKeyValueObservation!
//    private var workItem: DispatchWorkItem!
    private var imageLoadTask: Task<Void, Error>!
    
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
        button.setTitle("Cancel", for: .selected)
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
    
//    deinit {
//        observation.invalidate()
//        observation = nil
//    }
    
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
    
    private func resetView() {
        DispatchQueue.main.async {
            self.photoView.image = .init(systemName: "photo")
            self.progressView.progress = 0.0
            self.loadButton.isSelected = false
        }
    }
    
    @objc private func clickLoadButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        guard sender.isSelected else {
            imageLoadTask.cancel()
            resetView()
            return
        }
        downloadImage()
    }
}
// MARK: - Functions
extension ImageDownloadCell {
    func downloadImage() {
        if !loadButton.isSelected { loadButton.isSelected.toggle() }
        
        guard let url = URL(string: "https://source.unsplash.com/random") else { return }
        
        imageLoadTask =  Task(priority: .userInitiated) {
            photoView.image = try await repository.fetchImage(url: url)
            loadButton.isSelected = false
        }
        
//        Task.detached {
//            let image = try await self.repository.fetchImage(url: url)
//            await MainActor.run {
//                self.photoView.image = image
//            }
//        }
                
        /*
        workItem = DispatchWorkItem {
            guard !self.workItem.isCancelled else {
                self.resetView()
                return
            }
            
            self.repository.fetchImage { result in
                guard !self.workItem.isCancelled else {
                    self.resetView()
                    return
                }
                
                switch result {
                case .success(let image):
                    guard let image = image else {
                        DispatchQueue.main.async {
                            self.resetView()
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.photoView.image = image
                        self.loadButton.isSelected = false
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            self.observation = self.repository.task?.progress.observe(
                \.fractionCompleted,
                 options: .new,
                 changeHandler: { task, change in
                     DispatchQueue.main.async {
                         guard !self.workItem.isCancelled else {
                             self.observation.invalidate()
                             self.observation = nil
                             self.progressView.progress = 0.0
                             return
                         }
                         self.progressView.progress = Float(task.fractionCompleted)
                     }
                 })
        }
        
        DispatchQueue.global().async(execute: workItem)
         */
    }
}
