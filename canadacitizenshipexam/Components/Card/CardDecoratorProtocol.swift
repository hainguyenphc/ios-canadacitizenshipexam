//
//  CardDecoratorProtocol.swift
//  canadacitizenshipexam
//
//  Created by hainguyen on 2023-01-30.
//

import UIKit

protocol CardDecoratoProtocol: UIView, CardProtocol {

  var card: CardProtocol? {get set}

}
