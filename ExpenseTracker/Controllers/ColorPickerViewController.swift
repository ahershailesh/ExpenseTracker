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

struct ColorViewModel {
    let color : UIColor
    var isSelected : Bool
}

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate : ColorPickerDelegate?
    var selectedColor : UIColor?
    var selectedIndexPath : IndexPath?
    var colorModels : [ColorViewModel] = []
    
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
        if let indexPath = selectedIndexPath {
            let color = colorModels[indexPath.row].color
            delegate?.didSelectedcolor(color: color)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: ColorCollectionViewCell.self))
        
        collectionView.register(UINib(nibName: "LabelHeaderViewCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionReusableView", withReuseIdentifier: String(describing: LabelHeaderViewCollectionReusableView.self))
        
    }
}

extension ColorPickerViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ColorCollectionViewCell.self), for: indexPath) as? ColorCollectionViewCell
        cell?.model = colorModels[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionReusableView", withReuseIdentifier: String(describing: LabelHeaderViewCollectionReusableView.self), for: indexPath) as? LabelHeaderViewCollectionReusableView
        view?.textLabel.attributedText = NSAttributedString(string: "Select color", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return view ?? LabelHeaderViewCollectionReusableView()
    }
}

extension ColorPickerViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var model = colorModels.remove(at: indexPath.row)
        model.isSelected = true
        colorModels.insert(model, at: indexPath.row)
        if let indexPath = selectedIndexPath {
            var model = colorModels.remove(at: indexPath.row)
            model.isSelected = false
            colorModels.insert(model, at: indexPath.row)
        }
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
    
}
