//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 02.09.2022.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell {
    
    //MARK: SETUP
    
    var habitTapCallback: (() -> Void)?
    
    private let baseInset: CGFloat = 20
    private let imageSize: CGFloat = 36
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
    
    //MARK: Subview
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyHeadlineStyle()
        label.numberOfLines = 2
         return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyFootnoteStyle()
        label.textColor = .systemGray
          return label
    }()
    
    private lazy var trackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.applyCaptionStyle()
        label.applyFootnoteStyle()
        label.text = "Счётчик: \(habit.trackDates.count)"
          return label
     }()
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCornerWithRadius(18, top: true, bottom: true, shadowEnabled: false)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(checkBoxButtonPressed), for: .touchUpInside)
         return button
    }()
    
    private lazy var chekMarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.init(systemName: "checkmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
          return imageView
    }()
    
    //MARK: LIFECYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    //MARK: METHODS
    
    private func setupView() {
        contentView.roundCornerWithRadius(6, top: true, bottom: true, shadowEnabled: false)
        contentView.backgroundColor = .white
    }
    
    private func setupSubview() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(trackerLabel)
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(chekMarkImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: baseInset),
            nameLabel.trailingAnchor.constraint(equalTo: checkBoxButton.leadingAnchor, constant: -baseInset),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: baseInset),
            
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            trackerLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            trackerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -baseInset),
            
            checkBoxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),
            checkBoxButton.heightAnchor.constraint(equalToConstant: imageSize),
            checkBoxButton.widthAnchor.constraint(equalToConstant: imageSize),
            checkBoxButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -47),
            
            chekMarkImageView.centerXAnchor.constraint(equalTo: checkBoxButton.centerXAnchor),
            chekMarkImageView.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor)
      ])
    }
        
    
    
    //MARK: SET data
    
    func setData(habit: Habit) {
        self.habit = habit
        
        nameLabel.textColor = habit.color
        nameLabel.text = habit.name
        nameLabel.text = habit.dateString
        nameLabel.applyCaptionStyle()
        checkBoxButton.layer.borderColor = habit.color.cgColor
        trackerLabel.text = "Счетчик: \(habit.trackDates.count)"
        
        chekMarkImageView.isHidden = !habit.isAlreadyTakenToday
        
        if habit.isAlreadyTakenToday{
            checkBoxButton.backgroundColor = habit.color
        } else {
            checkBoxButton.backgroundColor = .white
        }
        
    }
    
    
    // MARK: Actions
    
    @objc func checkBoxButtonPressed() {
        if !habit.isAlreadyTakenToday{
            HabitsStore.shared.track(habit)
            checkBoxButton.backgroundColor = habit.color
        }
        habitTapCallback?()
        chekMarkImageView.isHidden = !habit.isAlreadyTakenToday
    }
    
}


