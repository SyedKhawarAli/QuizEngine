//
//  Flow.swift
//  QuizEngine
//
//  Created by shah on 26.8.2022.
//

import Foundation

protocol Router {
    typealias AnswerCallback = (String) -> Void
    func routeTo(question: String, answerCallBack: @escaping AnswerCallback)
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    init (questions: [String], router: Router){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: routeNext(from: firstQuestion))
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let strongSelf = self else { return }
            if let currentQuestionIndex = strongSelf.questions.firstIndex(of: question) {
                if currentQuestionIndex + 1 < strongSelf.questions.count {
                    let nextQuestion = strongSelf.questions[currentQuestionIndex + 1]
                    strongSelf.router.routeTo(question: nextQuestion, answerCallBack: strongSelf.routeNext(from: nextQuestion))
                }
            }
        }
    }
}
