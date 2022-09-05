//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 01.09.2022.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    //MARK: SUBVIEW
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Все получилось !"
        label.applyStatusFootnoteStyle()
         return label
    }()
    
    private lazy var habitsSlider: UISlider = {
       let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(), for: .normal)
        slider.setValue(HabitsStore.shared.todayProgress, animated: true)
        slider.tintColor = Styles.purpleColor
          return slider
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
        label.applyFootnoteStyle()
          return label
    }()
    
    //MARK: CYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: METHODS
    
    private func setupView(){
        contentView.roundCornerWithRadius(4, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
    }
    
    private func setupSubview() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(habitsSlider)
        contentView.addSubview(statusLabel)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            habitsSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            habitsSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            habitsSlider.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 10),
            habitsSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            habitsSlider.heightAnchor.constraint(equalToConstant: 7),
            
            statusLabel.trailingAnchor.constraint(equalTo: habitsSlider.trailingAnchor),
            statusLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor)
        
        ])
    }
    
    //MARK: METHODS
    
    func show() {
        habitsSlider.setValue(HabitsStore.shared.todayProgress, animated: true)
        statusLabel.text = String(Int(HabitsStore.shared.todayProgress * 100)) + "%"
    }
    
}
