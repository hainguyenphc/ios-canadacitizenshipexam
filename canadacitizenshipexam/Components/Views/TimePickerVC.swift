//
//  TimePickerVC.swift
//  canadacitizenshipexam
//
//  Created by HAI NGUYEN on 2026-08-25.
//

import UIKit

// A small modal sheet with a wheel-style time picker, presented over a
// dimmed background. Used by Home's "Practice Time" row to let the user
// pick their daily practice reminder time.
class TimePickerVC: UIViewController {

  private let initialHour: Int
  private let initialMinute: Int
  private let onSave: (_ hour: Int, _ minute: Int) -> Void

  private let datePicker = UIDatePicker()

  init(hour: Int, minute: Int, onSave: @escaping (_ hour: Int, _ minute: Int) -> Void) {
    self.initialHour = hour
    self.initialMinute = minute
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
      text: "Practice Time",
      textColor: .label,
      textAlignment: .center,
      fontSize: 18,
      fontWeight: .bold
    )
    panel.addSubview(titleLabel)

    datePicker.datePickerMode = .time
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.translatesAutoresizingMaskIntoConstraints = false
    var components = DateComponents()
    components.hour = initialHour
    components.minute = initialMinute
    if let date = Calendar.current.date(from: components) {
      datePicker.date = date
    }
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
    let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
    let hour = components.hour ?? initialHour
    let minute = components.minute ?? initialMinute
    dismiss(animated: true) { [weak self] in
      self?.onSave(hour, minute)
    }
  }

}
