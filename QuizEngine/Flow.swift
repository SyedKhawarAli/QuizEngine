//
//  Flow.swift
//  QuizEngine
//
//  Created by shah on 26.8.2022.
//

import Foundation

protocol Router {
    func routeTo(question: String, answerCallBack: @escaping (String) -> Void)
}

class Flow {
    let router: Router
    let questions: [String]
    
    init (questions: [String], router: Router){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: { [weak self] _ in
                guard let strongSelf = self else { return }
                let firstQuestionIndex = strongSelf.questions.firstIndex(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[firstQuestionIndex + 1]
                strongSelf.router.routeTo(question: nextQuestion, answerCallBack: { _ in })
            }
            )
        }
    }
}
