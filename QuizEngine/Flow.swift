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
    func routeTo(result: [String: String])
}

class Flow {
    private let router: Router
    private let questions: [String]
    
    private var result: [String: String] = [:]
    
    init (questions: [String], router: Router){
        self.router = router
        self.questions = questions
    }
    
    func start(){
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallBack: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: [:])
        }
    }
    
    private func nextCallback(from question: String) -> Router.AnswerCallback {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: String, _ answer: String){
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            result[question] = answer
            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion = questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion, answerCallBack: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result)
            }
        }
    }
}
