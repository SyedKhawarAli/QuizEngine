//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by shah on 26.8.2022.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {

    let router = RouterSpy()

    func test_start_withNoQuestion_doesNotRouteToQuestion(){
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestion_routesToCorrectQuestion(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestion_routesToCorrectQuestion_2(){
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_routesToFirstQuestion(){
        makeSUT(questions: ["Q1","Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice(){
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThirdQuestion(){
        let sut = makeSUT(questions: ["Q1","Q2", "Q3"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAnswerFirstQuestion_withOneQuestions_doesNotRoutesToAnotherQuestion(){
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallBack("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestion_routeToResult(){
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult!, [:])
    }
    
    func test_start_withOneQuestions_doesNotRouteToResult(){
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult(){
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")

        XCTAssertNil(router.routedResult)
    }
    
    func test_startAnswerFirstAndSecondQuestion_withTwoQuestions_routeToResult(){
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallBack("A1")
        router.answerCallBack("A2")

        XCTAssertEqual(router.routedResult!, ["Q1":"A1", "Q2":"A2"])
    }
    
    // MARK: Helpers
    
    func makeSUT(questions: [String]) -> Flow {
        return Flow(questions: questions, router: router)
    }
    
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var routedResult: [String: String]? = nil
        var answerCallBack: AnswerCallback = { _ in }
        
        func routeTo(question: String, answerCallBack: @escaping AnswerCallback ) {
            routedQuestions.append(question)
            self.answerCallBack = answerCallBack
        }
        
        func routeTo(result: [String : String]) {
            routedResult = result
        }
    }
}
