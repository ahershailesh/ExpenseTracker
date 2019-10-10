//
//  CreateTagViewController.swift
//  ExpenseTracker
//
//  Created by Shailesh Aher on 06/10/19.
//  Copyright © 2019 Shailesh Aher. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate : class {
    func didSelectedcolor(color: UIColor)
}

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate : ColorPickerDelegate?
    var selectedColor : UIColor?
    var selectedIndexPath : IndexPath?
    var colors : [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc private func saveButtonTapped() {
        if let selectedColor = selectedColor {
            delegate?.didSelectedcolor(color: selectedColor)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collectionView.register(UINib(nibName: "LabelHeaderViewCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionReusableView", withReuseIdentifier: String(describing: LabelHeaderViewCollectionReusableView.self))
        
    }
}

extension ColorPickerViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionReusableView", withReuseIdentifier: String(describing: LabelHeaderViewCollectionReusableView.self), for: indexPath) as? LabelHeaderViewCollectionReusableView
        view?.textLabel.attributedText = NSAttributedString(string: "Select color", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return view ?? LabelHeaderViewCollectionReusableView()
    }
}

extension ColorPickerViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
}
