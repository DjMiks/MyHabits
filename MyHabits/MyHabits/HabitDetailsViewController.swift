//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Максим Ялынычев on 01.09.2022.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    //MARK: DATA
    
    var habit = Habit(name: "Выпивать стакан воды перед завтраком", date: Date(), color: .systemRed)
    
    private lazy var habitDates: [Date] = {
        HabitsStore.shared.dates.reversed()
    }()
    
    // MARK: SIBVIEW
     
    private lazy var habitTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            HabitDetailViewCell.self,
          forCellReuseIdentifier: HabitDetailViewCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
          return tableView
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.doesRelativeDateFormatting = true
          return formatter
    }()
    
    // MARK: LEFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white
        
        setupView()
        setupSubview()
        setupConstraints()
    }
    
    private func setupView() {
        navigationController?.navigationBar.tintColor = Styles.purpleColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Править", style: .done, target: self, action: #selector(editButtoPressed)
        )
        navigationItem.title = habit.name
     }
    
    private func setupSubview() {
        view.addSubview(habitTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            habitTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            habitTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Actions
    
    @objc func editButtoPressed(_ sender:Any) {
        let viewController = AddHabitController()
        viewController.habit = habit
        viewController.addHabitType = .edit(removeAction: {[weak self] in self?.navigationController?.popToRootViewController(animated: true)
        })
        viewController.nameTextField.text = habit.name
        viewController.colorPickerView.backgroundColor = habit.color
        viewController.datePicker.date = habit.date
        viewController.nameTextField.textColor = habit.color
        present(viewController, animated: true, completion: nil)
    }
  }


//MARK: EXTESIONS

extension HabitDetailsViewController: UITableViewDelegate {
    
}

extension HabitDetailsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return habitDates.count
        }
    
    func tableView(
        _ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: HabitDetailViewCell.reuseID,
    for: indexPath) as! HabitDetailViewCell
            
            cell.textLabel?.text = dateFormatter.string(from: habitDates[indexPath.row])
            if HabitsStore.shared.habit(habit, isTrackedIn: habitDates[indexPath.row] ){
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
             return cell
          }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Активность"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true
        )
    }
}
