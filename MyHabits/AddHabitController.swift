//
//  AddHabitController.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 02.09.2022.
//

import UIKit




enum AddHabitType {
    case create(createAction: (() -> Void)?)
    case edit(removeAction: (() -> Void)?)
               
    var title: String {
        switch self {
        case .create:
            return "Создать"
        case .edit:
            return "Править"
        }
    }
              
   func callAction() {
        switch self {
        case .create(let createAction):
            createAction?()
        case .edit(let removeAction):
            removeAction?()
        }
    }
}

class AddHabitController: UIViewController {
    
    // MARK: Setup
    
    private let horizontalInset: CGFloat = 16
    private let imageSize: CGFloat = 30
    var addHabitType = AddHabitType.create(createAction: nil)
    
    //MARK: DATA
    
    var habit = Habit(name: "Выпить стакан воды перед завтраком", date: Date(), color: .systemRed)
    private lazy var habitStore: HabitsStore = {
        return HabitsStore.shared
    }()
    
    // MARK: SUBVIEW
    
    private lazy var navBar: UINavigstionBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem()
        let leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionCencelButton))
        let rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done, target: self, action: #selector(actionSaveButton))
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        leftBarButtonItem.tintColor = Styles.purpleColor
        reghtBarButtonItem.tintColor = Styles.purpleColor
        
        navItem.rightBarButtonItem = rightBarButtonItem
        navItem.leftBarButtonItem = leftBarButtonItem
        navItem.title = addHabitType.title
        
        navBar.setItems([navItem], animated: true)
        navBar.backgroundColor = .systemGray
           return navBar
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(dataPickerChanged(picker)), for: .valueChanged)
          return picker
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "НАЗВАНИЕ"
        label.applyFootnoteStyle()
        label.numberOfLines = 1
         return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.placeholder = "Бегать по утрам, спать 8 часов."
        textField.font = UIFont.systemFont(ofSize: 13, weight: .regular)
          return textField
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ЦВЕТ"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
         return label
    }()
    
    lazy var colorPickerView: UIView = {
        let view = UIView()
        view.roundCornerWithRadius(15, top: true, bottom: true, shadowEnabled: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = habit.color
        
        let tapColor = UITapGestureRecognizer(
            target: self, action: #selector(tapColorPicker))
         return view
    }()
    
    private lazy var colorPickerViewController: UIColorPickerViewController = {
        let controller = UIColorPickerViewController()
        controller.delegate = self
          return controller
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ВРЕМЯ"
        label.applyFootnoteStyle()
         return label
    }()
    
    lazy var habitTimeLabelText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Каждый день в"
         return label
    }()
    
    lazy var habitTimeLabelTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(dateFormatter.string(from: datePicker.date))"
        label.tintColor = Styles.purpleColor
        label.textColor = Styles.purpleColor
          return label
    }()
    
    private lazy var dataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
          return formatter
    }()
    
    private lazy var deleteHabitButton: UIButton = {
        let button = UIButton (type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить привычку", for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
          return button
    }()
    
    //MARK: Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubview()
        setupConstraints()
    }
    
    
    //MARK: Private METHOD
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupSubview() {
        
        view.addSubview(navBar)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(colorLabel)
        view.addSubview(colorPickerView)
        view.addSubview(timeLabel)
        view.addSubview(habitTimeLabelText)
        view.addSubview(habitTimeLabelTime)
        view?.addSubview(datePicker)
        
        if case .edit = addHabitType {
            self.view?.addSubview(self.deleteHabitButton)
            
            let constrForButton = [
                deleteHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                deleteHabitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ]
            NSLayoutConstraint.activate(constrForButton)
            
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
            navBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant:22),
            nameLabel.leadingAnchor.constraint(equalTo: view?.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                               constant: 7),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            colorPickerView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            colorPickerView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorPickerView.heightAnchor.constraint(equalTo: 30),
            colorPickerView.widthAnchor.constraint(equalTo: 30),
            
            timeLabel.topAnchor.constraint(equalTo: colorPickerView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            habitTimeLabelText.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            habitTimeLabelText.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            habitTimeLabelTime.topAnchor.constraint(equalTo: habitTimeLabelText.topAnchor),
            habitTimeLabelTime.leadingAnchor.constraint(equalTo: habitTimeLabelText.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: habitTimeLabelText.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    //MARK: action
    
    @objc func datePickerChanged(picker: UIDatePicker)
    if case .create = addHabitType {
        habit.date = datePicker.date
    }
    habitTimeLabelTime.text = "\(dateFormatter.string(from: datePicker.data))"


    @objc func tapColorPicker() {
    present(UIColorPickerViewController, animated: true, complection: nil)
}

    @objc func deleteButtonPressed() {
     
        let alertController = UIAlertController (
        title:"Удалить привычку",
        message: "Вы хотите удалить привычку \(habit.name)?",
        preferredStyle: .alert
        )
        
    let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in}
        
    let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
        HabitsStore.shared.habits.remove(at:
         HabitsStore.shared.habits.firstIndex(of: self.habit)! )
        self.addHabitType.callAction()
        self.dismiss(animated: true, completion: nil)
    }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
}
    
    @objc func actionCencelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
}

    @objc func actionSaveButton(_ sender: Any) {
      habit.name = nameTextField.text ?? habit.name
    if let color = colorPickerView.backgroundColor {
        habit.color = color
    }
    
    switch AddHabitType {
    case .create(let action): do {
        let store = HabitsStore.shared
        store.habits.append(habit)
        action?()
    }
    case .edit: do {
        habit.date = DatePicker.date
    }
        
  }
    habitStore.save()
    dismiss(animated: true, comletion: nil)
 }
    
}

 // MARK: extensions

extension AddHabitController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        habit.color = colorPickerViewController.selectedColor
        
        colorPickerView.backgroundColor = colorPickerViewController.selectedColor
    }
}

extension AddHabitController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
