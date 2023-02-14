//
//  ViewController.swift
//  loginPage
//
//  Created by 하연주 on 2023/02/10.
//

import UIKit

final class ViewController: UIViewController {


    // MARK: - 이메일 입력하는 텍스트 뷰
    private lazy var emailTextFieldView : UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true //radius설정할 떄 이것도 보통 같이 쓴다
        
        //🍑 addSubview : 위에 안내문구, 텍스트필드 얹혀주기 순서대로 얹힌다
        //🍑 private lazy 해야 한다!
        view.addSubview(emailInfoLabel) //emailTextFieldView를 private lazy var로 정의해줘야 한다
        view.addSubview(emailTextField)
        
        return view
    }()
    
    //"이메일 또는 전화번호" 안내문구
    private var emailInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "이메일 주소 또는 전화번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        
        return label
    }()
    
    private var emailTextField : UITextField = {
       let textField = UITextField()
        textField.frame.size.height = 48
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.tintColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .emailAddress
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        
        return textField
    }()
    
    // MARK: - 비밀번호 입력하는 텍스트 뷰
    private lazy var passwordTextFieldView : UIView = {
        let view = UIView()
        view.frame.size.height = 48
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        //🍑 addSubview : 위에 안내문구, 텍스트필드 얹혀주기 순서대로 얹힌다
        //🍑 private lazy 해야 한다!
        view.addSubview(passwordInfoLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSecureButton)
        
        return view
    }()
    
    //비밀번호 입력 안내문구
    private var passwordInfoLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        
        return label
    }()
    
    private var passwordTextField : UITextField = {
       let textField = UITextField()
        textField.frame.size.height = 48
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.tintColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        textField.isSecureTextEntry = true
        textField.clearsOnBeginEditing = false
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    //비밀번호에 "표시"버튼 비밀번호 가리기 기능
    private var passwordSecureButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(toggleSecureMode), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - 로그인버튼
    private let loginButton : UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.clipsToBounds = true //radius설정할 떄 이것도 보통 같이 쓴다
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        //🍑처음에는 버튼 비활성화
        button.isEnabled = false
        button.addTarget(self, action: #selector(logninButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    // MARK: stack view
    private lazy var stackView : UIStackView = {
//        let st = UIStackView()
        //stackView에 UI 에 올리는 방법
        let st = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        st.spacing = 18 //stackView 내부 간격
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .fill
        
        
        return st
    }()
    
    // MARK: 비밀번호 재설정 버튼
    private let passwordResetButton : UIButton = {
       let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    //3개의 각 텍스트필드 및 로그인 버튼의 높이 설정
    private let textViewHeight : CGFloat = 48
    
    private lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor)
    private lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    
    func makeUI() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(stackView)
        view.addSubview(passwordResetButton)
     
        /*
        //emailTextFieldView를 기준으로 위로 얹혀진 것(emailInfoLabel, emailTextField)위치 지정해주기
        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false

        emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
        emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8).isActive = true
        emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor, constant: 0).isActive = true  //label 과 textField를 y축을 동일하게 맞추기

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: 8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: 2).isActive = true
         */
        

        emailInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        passwordResetButton.translatesAutoresizingMaskIntoConstraints = false
        
        //.isActive = true 대신에 쓸 수 있는것
        NSLayoutConstraint.activate([
            
            //⭐️ emailTextFieldView를 기준으로 위로 얹혀진 것(emailInfoLabel, emailTextField)위치 지정해주기
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8),
            //❌ 나중에 변경되는 레이아웃이기때문에 이렇게 정의해두면 안된다
//            emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor, constant: 0), //label 과 textField를 y축을 동일하게
            //⭕️
            emailInfoLabelCenterYConstraint,
            
            emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8),
            emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15),
            emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: -2),
            
            //⭐️ passwordTextFieldView를 기준으로 위로 얹혀진 것(passwordInfoLabel, passwordTextField, passwordSecureButton)위치 지정해주기
            passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            //❌ 나중에 변경되는 레이아웃이기때문에 이렇게 정의해두면 안된다
//            passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor), //label 과 textField를 y축을 동일하게
//            passwordInfoLabelCenterYConstraints.isActive = true
            //⭕️
            passwordInfoLabelCenterYConstraint,
            
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -2),
            
            passwordSecureButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8),
            passwordSecureButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15),
            passwordSecureButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15),

            //⭐️ view를 기준으로 stackView의 위치 설정해주기
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: textViewHeight*3 + 36), //textViewHeight를 상수로 설정해놓고 사용
            
            
            //⭐️ stackView를 기준으로 passwordResetButton의 위치 설정해주기10
            passwordResetButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            //아니면 이렇게 해 줄수도
//            passwordResetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            passwordSecureButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 30),
            passwordResetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant : 10), //stackView의 bottom 을 기준으로 10밑에 passwordResetButton의 topAnchor 가 올 수 있도록
            passwordResetButton.heightAnchor.constraint(equalToConstant: textViewHeight)  //textViewHeight를 상수로 설정해놓고 사용

            
            
            
            
        ])
    }
    
    @objc func resetButtonTapped() {
//        print("리셋버튼이 눌렸습니다.")
        let alert = UIAlertController(title: "비밀번호 재설정", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "네", style: .default){ yes in
            print(yes)
            print("defaultAction")
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel){ _ in
            print("cancelAction")
        }
        let destructiveAction = UIAlertAction(title: "아니오", style: .destructive){ _ in
            print("destructiveAction")
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
        
        self.present(alert, animated: true){
            print("알림창 열림!!")
        }
    }
    
    @objc func toggleSecureMode () {
        passwordTextField.isSecureTextEntry.toggle()
        passwordSecureButton.setTitle(passwordTextField.isSecureTextEntry ? "표시" : "가리기", for: .normal)
    }
    
    //⭐️ 로그인버튼 활성화 방법 2
    @objc func textFieldEditingChanged (_ textField : UITextField) {
        guard emailTextField.text != nil && passwordTextField.text != nil else {return }
        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("키보드 외의 영역 클릭")
        self.view.endEditing(true)
    }
    
    @objc func logninButtonTapped () {
        print("로그인 버튼이 눌렀습니다.")
    }

}


extension ViewController : UITextFieldDelegate{

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == emailTextField {
            print("이메일 입력 텍스트필드 클릭했다!")
            emailTextFieldView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            //label의 크기 줄이기
            emailInfoLabel.font = UIFont.systemFont(ofSize: 11)
            //label의 위치 이동
            //이렇게하면 안됨!❌ 오토레이아웃을 변경할 때는 변수에다가 넣어주고 그 변수로 사용해줘야한다
            //emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor, constant: -13).isActive = true
            //⭕️
            emailInfoLabelCenterYConstraint.constant = -13
            
        } else if textField == passwordTextField {
            print("비밀번호 입력 텍스트필드 클릭했다!!")
            passwordTextFieldView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            //label의 크기 줄이기
            passwordInfoLabel.font = UIFont.systemFont(ofSize: 11)
            //label의 위치 이동
            //이렇게하면 안됨!❌ 오토레이아웃을 변경할 때는 변수에다가 넣어주고 그 변수로 사용해줘야한다
            //passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor, constant: -13).isActive = true
            //⭕️
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        //에니메이션 효과 주고싶을 때
        UIView.animate(withDuration: 0.3, animations: { self.stackView.layoutIfNeeded() } )
        

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == emailTextField {
            emailTextFieldView.backgroundColor = .darkGray
            if textField.text == "" { //아무것도 작성하지 않았을 때는 label 원상태 복구
                emailInfoLabel.font = UIFont.systemFont(ofSize: 18)
                //이렇게하면 안됨!❌ 오토레이아웃을 변경할 때는 변수에다가 넣어주고 그 변수로 사용해줘야한다
                //emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor).isActive = true
                emailInfoLabelCenterYConstraint.constant = 0
            }
        }else if textField == passwordTextField {
            passwordTextFieldView.backgroundColor = .darkGray
            if textField.text == "" { //아무것도 작성하지 않았을 때는 label 원상태 복구
                passwordInfoLabel.font = UIFont.systemFont(ofSize: 18)
                //이렇게하면 안됨!❌ 오토레이아웃을 변경할 때는 변수에다가 넣어주고 그 변수로 사용해줘야한다
                //passwordInfoLabel.centerYAnchor.constraint(equalTo: passwordTextFieldView.centerYAnchor).isActive = true
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
    }
    
    
    //⭐️ 로그인버튼 활성화 방법 1
//    func textFieldDidChangeSelection(_ textField: UITextField) { // 사용자 입력값이 변경된 후 호출되기 떄문에 입력 이후 텍스트로 출력할 수 있다
//        guard emailTextField.text != nil && passwordTextField.text != nil else {return }
//        if !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
//            loginButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//            loginButton.isEnabled = true
//        } else {
//            loginButton.backgroundColor = .clear
//            loginButton.isEnabled = false
//        }
//    }]


}
