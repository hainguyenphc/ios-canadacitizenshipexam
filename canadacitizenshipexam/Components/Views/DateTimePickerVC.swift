//
//  DateTimePickerVC.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit

// A small modal sheet with a wheel-style UIDatePicker, presented over a
// dimmed background. Used by Home's "Practice Time" row (mode: .time) and
// its "Schedule your Exam" row (mode: .dateAndTime), and by Settings'
// "Practice Time" row.
class DateTimePickerVC: UIViewController {

  private let heading: String
  private let mode: UIDatePicker.Mode
  private let initialDate: Date
  private let minimumDate: Date?
  private let onSave: (Date) -> Void

  private let datePicker = UIDatePicker()

  init(
    heading: String,
    mode: UIDatePicker.Mode,
    initialDate: Date,
    minimumDate: Date? = nil,
    onSave: @escaping (Date) -> Void
  ) {
    self.heading = heading
    self.mode = mode
    self.initialDate = initialDate
    self.minimumDate = minimumDate
    self.onSave = onSave
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  private func configureUI() {
    view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

    let panel = UIView()
    panel.translatesAutoresizingMaskIntoConstraints = false
    panel.backgroundColor = .secondarySystemGroupedBackground
    panel.layer.cornerRadius = 16
    view.addSubview(panel)

    let titleLabel = ScreenTitleLabel(
      text: heading,
      textColor: .label,
      textAlignment: .center,
      fontSize: 18,
      fontWeight: .bold
    )
    panel.addSubview(titleLabel)

    datePicker.datePickerMode = mode
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    if let minimumDate = minimumDate {
      datePicker.minimumDate = minimumDate
    }
    // Set after minimumDate, so an initialDate that's earlier than
    // minimumDate gets clamped forward by UIDatePicker itself rather than
    // silently rejected.
    datePicker.date = initialDate
    panel.addSubview(datePicker)

    let cancelButton = UIButton(type: .system)
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(.secondaryLabel, for: .normal)
    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    panel.addSubview(cancelButton)

    let saveButton = CCEButton(backgroundColor: APP_ACCENT_COLOR, title: "Save")
    saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    panel.addSubview(saveButton)

    NSLayoutConstraint.activate([
      panel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      panel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      panel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
      panel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),

      titleLabel.topAnchor.constraint(equalTo: panel.topAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 15),
      titleLabel.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -15),

      datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      datePicker.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
      datePicker.trailingAnchor.constraint(equalTo: panel.trailingAnchor),

      cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
      cancelButton.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: 20),
      cancelButton.bottomAnchor.constraint(equalTo: panel.bottomAnchor, constant: -20),

      saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
      saveButton.trailingAnchor.constraint(equalTo: panel.trailingAnchor, constant: -20),
      saveButton.widthAnchor.constraint(equalToConstant: 90),
      saveButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  @objc private func cancelTapped() {
    dismiss(animated: true)
  }

  @objc private func saveTapped() {
    let selectedDate = datePicker.date
    dismiss(animated: true) { [weak self] in
      self?.onSave(selectedDate)
    }
  }

}
