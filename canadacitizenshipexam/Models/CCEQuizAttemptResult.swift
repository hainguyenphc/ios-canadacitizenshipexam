//
//  CCEQuizAttemptResult.swift
//  canadacitizenshipexam
//

import Foundation

// The response from the score_quiz_attempt Cloud Function — see
// ios-canadacitizenshipexam-cloud-functions/functions/main.py. Nothing on
// the client computes a score anymore; this is the one and only place a
// score for an attempt comes from.
struct CCEQuizAttemptResult {

  var correctCount: Int!

  var totalQuestions: Int!

  var scorePercent: Float!

  var finishedAt: Date!

}
