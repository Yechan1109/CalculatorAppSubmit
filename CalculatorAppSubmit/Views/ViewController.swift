import UIKit

class ViewController: UIViewController {
    
    
    // MARK: -
    private let buttonNames = [
        ["7", "8", "9", "+"], // 각 array는 row, row 안의 개별 값은 value
        ["4", "5", "6", "-"],
        ["1", "2", "3", "*"],
        ["AC", "0", "=", "/"]
    ]
    
    private var currentValue: String = ""
    
    // 계산기 동작 Outputlabel
    private let outputLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor(hexCode: "#ffffff") // extension UIColor로 헥스코드 사용
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
    
    
    // MARK: - 레이아웃 func
    
    // 오토레이아웃
    private func configureUI() {
        view.backgroundColor = .black
        //        view.addSubview(outputLabel) + view.addSubview(hstackView) -> foreach로 각각 할당
        [outputLabel, vstackView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            outputLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            outputLabel.heightAnchor.constraint(equalToConstant: 100),
            
            vstackView.widthAnchor.constraint(equalToConstant: 350), // 버튼 크기 80, spacing 10 -> (80*4) + (10*3) = 350
            vstackView.heightAnchor.constraint(equalToConstant: 350),
            vstackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vstackView.topAnchor.constraint(equalTo: outputLabel.bottomAnchor, constant: 60),
        ])
    }
    
    // 버튼 및 horizon stackview 설정
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
                if ["+", "-", "*", "/", "=", "AC"].contains(value) {
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
    
    
    // MARK: - 버튼 클릭 동작 기능 func
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let getTitle = sender.currentTitle else { return }
        
        // switch문으로 기능 분할
        switch getTitle {
        case "0"..."9", "+", "-", "*", "/":
            if currentValue == "0" {        // 처음 0값시 표기 삭제
                currentValue = getTitle
            } else {
                currentValue += getTitle
            }
            outputLabel.text = currentValue
        case "=":
            resultOperation()
        case "AC":
            clear()
        default:
            break
        }
    }
    
    // 초기화 버튼(AC) 구현
    private func clear() {
        currentValue = "0"
        outputLabel.text = "0"
    }
    
    // "=" 연산 수행 구현
    private func resultOperation() {
        if let result = calculate(currentValue) {
            outputLabel.text = "\(result)"
            currentValue = "\(result)"
        } else {
            currentValue = "0"
        }
    }
    
    // 값과 수식을 계산하는 NSExpression 사용
    private func calculate(_ expression: String) -> Int? {
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
// MARK: -
#Preview {
    ViewController()
}
