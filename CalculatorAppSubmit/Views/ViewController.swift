import UIKit

class ViewController: UIViewController {
    
    private let buttonNames = [
        ["7", "8", "9", "+"], // 각 array는 row, row 안의 개별 값은 value
        ["4", "5", "6", "-"],
        ["1", "2", "3", "*"],
        ["AC", "0", "=", "/"]
    ]
    
    private var currentExpression: String = ""

    // 계산기 동작 view label
    private let outputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor(hexCode: "#ffffff")
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // VstackView
    private let vstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .black
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setButtons()
        
    }
    
    
//          오토레이아웃 설정
    private func configureUI() {
        view.backgroundColor = .black
//        view.addSubview(outputLabel) + view.addSubview(hstackView) -> foreach로 각각 할당
        [outputLabel, vstackView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            outputLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            outputLabel.heightAnchor.constraint(equalToConstant: 100),
            
            vstackView.widthAnchor.constraint(equalToConstant: 350),
            vstackView.heightAnchor.constraint(equalToConstant: 350),
            vstackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vstackView.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 60),
        ])
    }

    // 버튼 및 stackview 교차 관련 세팅
    private func setButtons() {
        for row in buttonNames {
            let hstackView = UIStackView()
            hstackView.axis = .horizontal
            hstackView.spacing = 10
            hstackView.distribution = .fillEqually
            
            for value in row {
                let button = UIButton()
                button.setTitle(value, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                // 버튼 기능별 컬러값 주기
                button.layer.cornerRadius = 40
                if ["+", "-", "*", "/", "="].contains(value) {
                    button.backgroundColor = UIColor(hexCode: "#FE5A1D")
                } else {
                    button.backgroundColor = UIColor(hexCode: "#808080")
                }
                button.translatesAutoresizingMaskIntoConstraints = false
                hstackView.addArrangedSubview(button)
                //
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            }
            vstackView.addArrangedSubview(hstackView)
        }
    }
    
    
        
        @objc private func buttonTapped(_ sender: UIButton) {
                guard let getTitle = sender.currentTitle else { return }
                
                switch getTitle {
                case "0"..."9", "+", "-", "*", "/":
                    if currentExpression == "0" {
                        currentExpression = getTitle
                    } else {
                        currentExpression += getTitle
                    }
                    outputLabel.text = currentExpression
                case "=":
                    actOperation()
                case "AC":
                    clear()
                default:
                    break
                }
            }
    
        private func actOperation() {
            if let result = calculate(expression: currentExpression) {
                outputLabel.text = "\(result)"
                currentExpression = "\(result)"
            } else {
                currentExpression = "0"
            }
        }
        
        private func clear() {
            currentExpression = "0"
            outputLabel.text = "0"
        }
        
        // 수식 문자열을 넣으면 계산해주는 메서드
        private func calculate(expression: String) -> Int? {
            let expression = NSExpression(format: expression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Int {
                return result
            } else {
                return nil
            }
        }

}


// UIColor rgb -> hex 값으로 대체하기 위함
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

//@available(iOS 17.0, *)
#Preview {
    ViewController()
}
