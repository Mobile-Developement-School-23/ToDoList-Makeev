
import UIKit

class ToDoItemAddScreen: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        let hsv: UIStackView = {
            let v = UIStackView()
            v.axis = .horizontal
            v.alignment = .center
            v.distribution = .equalSpacing
            return v
        }()
         let cancelButton: UIButton = {
            let button = UIButton(type: .system)
             button.setTitle("Отменить", for: .normal)
             button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
             
            return button
        }()
        let saveButton: UIButton = {
           let button = UIButton(type: .system)
            button.setTitle("Сохранить", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            
           return button
       }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Дело"
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .black
            return label
        }()
        
        let vertStackView: UIStackView = {
           let vsv = UIStackView()
            vsv.axis = .vertical
            vsv.alignment = .fill
            vsv.spacing = 10
            return vsv
        }()
        
        let scrView: UIScrollView = {
            let scrv = UIScrollView()
            return scrv
        }()
        
        
        let scrViewVS: UIStackView = {
            let scv = UIStackView()
            scv.axis = .vertical
            scv.spacing = 16
            scv.alignment = .fill
            return scv
        }()
        
        let txtField: UITextView = {
           let tf = UITextView()
            tf.textContainer.lineFragmentPadding = 16
            tf.text = "Что надо сделать?"
            tf.textColor = UIColor.lightGray
            tf.isEditable = true
            tf.delegate = self
            tf.layer.cornerRadius = 16
            tf.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            return tf
        }()
        
        
        hsv.addArrangedSubview(cancelButton)
        hsv.addArrangedSubview(titleLabel)
        hsv.addArrangedSubview(saveButton)
        scrView.addSubview(scrViewVS)
        scrViewVS.addArrangedSubview(txtField)
        vertStackView.addArrangedSubview(hsv)
        vertStackView.addArrangedSubview(scrView)
        
        view.addSubview(vertStackView)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        hsv.translatesAutoresizingMaskIntoConstraints = false
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        scrView.translatesAutoresizingMaskIntoConstraints = false
        scrViewVS.translatesAutoresizingMaskIntoConstraints = false
        txtField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vertStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vertStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vertStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hsv.heightAnchor.constraint(equalToConstant: 56),
            txtField.heightAnchor.constraint(equalToConstant: 120),
            scrView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrView.topAnchor.constraint(equalTo: hsv.bottomAnchor, constant: 10),
            scrViewVS.leadingAnchor.constraint(equalTo: scrView.leadingAnchor),
            scrViewVS.trailingAnchor.constraint(equalTo: scrView.trailingAnchor),
            scrViewVS.widthAnchor.constraint(equalTo: scrView.widthAnchor),
            txtField.widthAnchor.constraint(equalTo: scrViewVS.widthAnchor)
        ])
        

        
        // Do any additional setup after loading the view.

    }
}


extension ToDoItemAddScreen: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = UIColor.lightGray
        }
    }
}
