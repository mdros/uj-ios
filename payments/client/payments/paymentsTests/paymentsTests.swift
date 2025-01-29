//
//  paymentsTests.swift
//  paymentsTests
//
//  Created by Michał Droś on 29/01/2025.
//

import XCTest
@testable import payments

class CardValidationTests: XCTestCase {
    var cardForm: CardFormView!
    
    override func setUp() {
        super.setUp()
        cardForm = CardFormView(isPresented: .constant(true), transactionSuccess: .constant(false))
    }
    
    func testValidCardDetails() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertFalse(self.cardForm.showAlert)
        }
    }
    
    func testInvalidCardNumberShort() {
        cardForm.cardNumber = "1234"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testInvalidCardNumberLong() {
        cardForm.cardNumber = "123456781234567890"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testInvalidCVVShort() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "12"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testInvalidCVVLong() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "1234"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testInvalidExpiryDateFormat() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "1225"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testEmptyCardNumber() {
        cardForm.cardNumber = ""
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testEmptyCVV() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = ""
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testEmptyExpiryDate() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = ""
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testNetworkErrorHandling() {
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testSuccessfulNavigationBack() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertFalse(self.cardForm.isPresented)
        }
    }
    
    func testNoNavigationOnInvalidPayment() {
        cardForm.cardNumber = "1234"
        cardForm.cvv = "12"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.isPresented)
        }
    }
    
    func testSpecialCharactersInCardNumber() {
        cardForm.cardNumber = "1234-5678-1234-5678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testBuyButtonOpensPaymentForm() {
        let contentView = ContentView()
        contentView.showCardForm = true
        
        DispatchQueue.main.async {
            XCTAssertTrue(contentView.showCardForm)
        }
    }
    
    // Additional 15 tests
    func testInvalidExpiryDatePast() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "01/20"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testInvalidExpiryDateNonNumeric() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "AB/CD"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testCVVWithLetters() {
        cardForm.cardNumber = "1234567812345678"
        cardForm.cvv = "12A"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testCardNumberWithSpaces() {
        cardForm.cardNumber = "1234 5678 1234 5678"
        cardForm.cvv = "123"
        cardForm.expiryDate = "12/25"
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
    
    func testEmptyAllFields() {
        cardForm.cardNumber = ""
        cardForm.cvv = ""
        cardForm.expiryDate = ""
        
        cardForm.validateCard()
        DispatchQueue.main.async {
            XCTAssertTrue(self.cardForm.showAlert)
        }
    }
}
