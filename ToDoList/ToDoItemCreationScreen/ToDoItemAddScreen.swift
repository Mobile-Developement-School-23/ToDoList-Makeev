
import UIKit

class ToDoItemAddScreen: UIViewController {
    private let textViewMaxHeight: CGFloat = 120

    lazy var scrView: UIScrollView = {
        let scr = UIScrollView()
        scr.contentSize = view.bounds.size
        scr.showsVerticalScrollIndicator = true
        return scr
    }()

    @objc private func hideKeyboard() {
        txtField.resignFirstResponder()
    }

    lazy var scrViewVS: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 16
        vStack.alignment = .fill
        return vStack
    }()

    lazy var txtField: UITextView = {
        let txtf = UITextView()
        txtf.text = "Что надо сделать?"
        txtf.font = UIFont.body ?? UIFont.systemFont(ofSize: 17)
        txtf.textColor = .lablelTertiary
        txtf.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 16, right: 16)
        txtf.backgroundColor = UIColor.backSecondary
        txtf.delegate = self
        txtf.layer.cornerRadius = 16
        txtf.isScrollEnabled = false
        txtf.resignFirstResponder()
        return txtf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backPrimary

        lazy var cancelButton: UIBarButtonItem = {
            let cbutton = UIBarButtonItem(title: "Отмена", image: nil, target: nil, action: nil)
            return cbutton
        }()

        lazy var saveButton: UIBarButtonItem = {
            let sbutton = UIBarButtonItem(
                title: "Сохранить", style: .plain, target: nil, action: nil
            )

            return sbutton
        }()

        scrView.translatesAutoresizingMaskIntoConstraints = false
        scrViewVS.translatesAutoresizingMaskIntoConstraints = false
        txtField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrView)
        scrView.addSubview(scrViewVS)
        scrViewVS.addArrangedSubview(txtField)

        NSLayoutConstraint.activate([
            scrView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            scrViewVS.leadingAnchor.constraint(equalTo: scrView.contentLayoutGuide.leadingAnchor, constant: 16),
            scrViewVS.trailingAnchor.constraint(equalTo: scrView.contentLayoutGuide.trailingAnchor, constant: -16),
            scrViewVS.topAnchor.constraint(equalTo: scrView.contentLayoutGuide.topAnchor, constant: 16),
            scrViewVS.bottomAnchor.constraint(equalTo: scrView.contentLayoutGuide.bottomAnchor, constant: 16),
            scrViewVS.leadingAnchor.constraint(equalTo: scrView.frameLayoutGuide.leadingAnchor, constant: 16),
            scrViewVS.trailingAnchor.constraint(equalTo: scrView.frameLayoutGuide.trailingAnchor, constant: -16),

            txtField.heightAnchor.constraint(greaterThanOrEqualToConstant: textViewMaxHeight),
            txtField.bottomAnchor.constraint(equalTo: scrView.bottomAnchor, constant: -16),

        ])

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)

        let saveAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.headLine ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.colorBlue,
        ]
        let cancelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.body ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.colorBlue,
        ]

        title = "Дело"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.headLine ?? UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.labelPrimery,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        saveButton.setTitleTextAttributes(saveAttributes, for: .normal)
        cancelButton.setTitleTextAttributes(cancelAttributes, for: .normal)

        // Do any additional setup after loading the view.
    }
}

extension ToDoItemAddScreen: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        let fWidth = txtField.frame.size.width
        let nSize = txtField.sizeThatFits(CGSize(width: fWidth, height: CGFloat.greatestFiniteMagnitude))
        txtField.frame.size.height = max(nSize.height, textViewMaxHeight)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lablelTertiary {
            textView.text = nil
            textView.textColor = UIColor.labelPrimery
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor.lablelTertiary
        }
    }
}
