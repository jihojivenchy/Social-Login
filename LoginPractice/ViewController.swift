//
//  ViewController.swift
//  LoginPractice
//
//  Created by 엄지호 on 2023/01/11.
//

import UIKit
import SnapKit
import KakaoSDKUser
import AuthenticationServices //애플로그인
import Alamofire
import NaverThirdPartyLogin

class ViewController: UIViewController {
    let backGroundView = UIView()
    let idTextField = UITextField()
    let pwTextField = UITextField()
    
    let loginButton = UIButton()
    
    let stackView = UIStackView()
    let kakaoButton = UIButton()
    let appleButton = UIButton()
    let naverButton = UIButton()
    let facebookButton = UIButton()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
    }

    func addSubViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(backGroundView)
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 10
        backGroundView.layer.borderColor = UIColor.darkGray.cgColor
        backGroundView.layer.borderWidth = 1
        backGroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(120)
        }
        
        backGroundView.addSubview(idTextField)
        idTextField.placeholder = "아이디를 입력해주세요."
        idTextField.textColor = .black
        idTextField.tintColor = .black
        idTextField.clearButtonMode = .whileEditing
        idTextField.font = .boldSystemFont(ofSize: 16)
        idTextField.backgroundColor = .clear
        idTextField.clipsToBounds = true
        idTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        backGroundView.addSubview(pwTextField)
        pwTextField.placeholder = "비밀번호를 입력해주세요."
        pwTextField.font = .boldSystemFont(ofSize: 16)
        pwTextField.backgroundColor = .clear
        pwTextField.textColor = .black
        pwTextField.tintColor = .black
        pwTextField.clearButtonMode = .whileEditing
        addTopBorder()
        pwTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview().inset(17)
            make.height.equalTo(55)
        }
        
        view.addSubview(loginButton)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.textColor = .black
        loginButton.backgroundColor = .blue
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 10
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(50)
        }
        
        kakaoButton.setBackgroundImage(UIImage(named: "kakao"), for: .normal)
        kakaoButton.addTarget(self, action: #selector(kakaoLoginPressed(_:)), for: .touchUpInside)
        kakaoButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
        }
        
        naverButton.setBackgroundImage(UIImage(named: "naver"), for: .normal)
        naverButton.addTarget(self, action: #selector(naverLoginPressed(_:)), for: .touchUpInside)
        naverButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
        }
        
        
        appleButton.setBackgroundImage(UIImage(named: "apple"), for: .normal)
        appleButton.addTarget(self, action: #selector(appleLoginPressed(_:)), for: .touchUpInside)
        appleButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
        }
        
        facebookButton.setBackgroundImage(UIImage(named: "facebook"), for: .normal)
        facebookButton.addTarget(self, action: #selector(facebookLoginPressed(_:)), for: .touchUpInside)
        facebookButton.snp.makeConstraints { make in
            make.width.height.equalTo(42)
        }
        
        view.addSubview(stackView)
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(naverButton)
        stackView.addArrangedSubview(appleButton)
        stackView.addArrangedSubview(facebookButton)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
        
    }
    
    
    
    func addTopBorder() {
        let border = UIView()
        border.backgroundColor = .darkGray
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: pwTextField.frame.width, height: 1)
        pwTextField.addSubview(border)
    }
    
    
    
    @objc func kakaoLoginPressed(_ sender : UIButton) {

        if (UserApi.isKakaoTalkLoginAvailable()) {  // 카카오톡 설치 여부 확인
            
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오톡 로그인 성공")

                    //성공 후 돌릴 작업들
                    
                }
            }
            
        }else{
            print("카톡설치부탁")
            
            //카톡을 설치하거나 아래 작업처럼 카카오 계정을 입력해서 로그인
//            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("카카오 계정으로 로그인 성공")
//                    
//                    _ = oauthToken
//                    // 관련 메소드 추가
//                }
//            }
            
        }
    }
    
    @objc func naverLoginPressed(_ sender : UIButton) {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.delegate = self
        instance?.requestThirdPartyLogin()
    }
    
    @objc func appleLoginPressed(_ sender : UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
   
    @objc func facebookLoginPressed(_ sender : UIButton) {
        
    }
    
}

extension ViewController : ASAuthorizationControllerDelegate {
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")

        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error")
    }
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }//버튼을 눌렀을때 Apple 로그인을 모달 시트로 표시하는 함수입니다.
    
}

extension ViewController : NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("로그인 성공 json 형식의 필요한 데이터(이메일, 닉네임) 가져오셈 ")
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("토큰")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("로그아웃")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
    
    
}
