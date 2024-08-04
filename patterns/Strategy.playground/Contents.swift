
protocol PaymentStrategy {
    func processPayment(amount: Double)
}

class CreditCardPaymentStrategy : PaymentStrategy {
    func processPayment(amount: Double) {
        print("Processing credit card payment of amount: R$\(amount)")
    }
}

class DebitCardPaymentStrategy : PaymentStrategy {
    func processPayment(amount: Double) {
        print("Processing debit card payment of amount: R$\(amount)")
    }
}

class PixPaymentStrategy : PaymentStrategy {
    func processPayment(amount: Double) {
        print("Processing pix payment of amount: R$\(amount)")
    }
}

class CashPaymentStrategy : PaymentStrategy {
    func processPayment(amount: Double) {
        print("Processing cash payment of amount: R$\(amount)")
    }
}

class PaymentProcessor {
    let paymentStrategy: PaymentStrategy;
    
    init(paymentStrategy: PaymentStrategy) {
        self.paymentStrategy = paymentStrategy
    }
    
    func processPayment(amount: Double) {
        paymentStrategy.processPayment(amount: amount)
    }
}

let processor = PaymentProcessor(paymentStrategy: CashPaymentStrategy())
processor.processPayment(amount: 1000.0)
