protocol TransportStrategy {
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket
    func calculateTicketPrice(origin: State, destination: State) -> Double
}

class AirplaneTransport: TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard let distance = origin.distance(to: destination) else { return 0.0 }
        let transportFactor = 0.3
        let tax = 100.0
        let price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket {
        let price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName, origin: origin, destination: destination, transport: Transport.airplane, price: price)
    }
}

class TrainTransport: TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard let distance = origin.distance(to: destination) else { return 0.0 }
        let transportFactor = 0.2
        let tax = 50.0
        let price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket {
        let price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName, origin: origin, destination: destination, transport: Transport.train, price: price)
    }
}

class BusTransport: TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard let distance = origin.distance(to: destination) else { return 0.0 }
        let transportFactor = 0.1
        let tax = 30.0
        let price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket {
        let price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName, origin: origin, destination: destination, transport: Transport.bus, price: price)
    }
}

class TransportContext {
    private var strategy: TransportStrategy?
    
    func setTransportStrategy(strategy: TransportStrategy) {
        self.strategy = strategy
    }
    
    func executeBooking(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket? {
        guard let strategy = strategy else {
            print("Transport strategy not set.")
            return nil
        }
        return strategy.book(ticketID: ticketID, passengerName: passengerName, origin: origin, destination: destination)
    }
}

enum Transport: String {
    case airplane = "Airplane"
    case train = "Train"
    case bus = "Bus"
}

struct Ticket {
    let ticketId: String
    let passengerName: String
    let origin: State
    let destination: State
    let transport: Transport
    let price: Double
    
    var successMessage: String {
        return """
        A passagem foi reservada com sucesso.
        Id: \(ticketId)
        Origem: \(origin.rawValue)
        Destino: \(destination.rawValue)
        Transporte: \(transport.rawValue)
        Passageiro: \(passengerName)
        Valor total: \(price).
        """
    }
    
    var info: String {
        return """
        Informações da passagem:
        Id: \(ticketId)
        Origem: \(origin.rawValue)
        Destino: \(destination.rawValue)
        Transporte: \(transport.rawValue)
        Passageiro: \(passengerName)
        Valor total: \(price).
        """
    }
}

class ReservationSystem {
    private var reservations: [Transport: [Ticket]] = [:]
    private let context = TransportContext()
    
    func addReservation(transport: Transport, ticketID: String, passengerName: String, origin: State, destination: State) {
        switch transport {
        case .airplane:
            context.setTransportStrategy(strategy: AirplaneTransport())
        case .bus:
            context.setTransportStrategy(strategy: BusTransport())
        case .train:
            context.setTransportStrategy(strategy: TrainTransport())
        }
        
        if let newTicket = context.executeBooking(ticketID: ticketID, passengerName: passengerName, origin: origin, destination: destination) {
            reservations[transport, default: []].append(newTicket)
            print(newTicket.successMessage)
        }
    }
    
    func listAllReservations() {
        for (transport, reservationList) in reservations {
            print("\(transport.rawValue) reservations:")
            for reservation in reservationList {
                print(reservation.info)
            }
        }
    }
    
    func searchReservations(transport: Transport) {
        if let reservationList = reservations[transport] {
            print("\(transport.rawValue) reservations:")
            for reservation in reservationList {
                print(reservation.info)
            }
        } else {
            print("No reservations found for \(transport.rawValue).")
        }
    }
}

enum State: String {
    case alagoas = "Alagoas"
    case bahia = "Bahia"
    case ceara = "Ceará"
    case rioDeJaneiro = "Rio de Janeiro"
    case saoPaulo = "São Paulo"
    case minasGerais = "Minas Gerais"

    private static let distances: [State: [State: Double]] = [
        .alagoas: [
            .bahia: 875.0,
            .ceara: 1037.0,
            .rioDeJaneiro: 1950.0,
            .saoPaulo: 2140.0,
            .minasGerais: 1620.0
        ],
        .bahia: [
            .alagoas: 875.0,
            .ceara: 1213.0,
            .rioDeJaneiro: 1530.0,
            .saoPaulo: 1942.0,
            .minasGerais: 1370.0
        ],
        .ceara: [
            .alagoas: 1037.0,
            .bahia: 1213.0,
            .rioDeJaneiro: 2688.0,
            .saoPaulo: 2760.0,
            .minasGerais: 2230.0
        ],
        .rioDeJaneiro: [
            .alagoas: 1950.0,
            .bahia: 1530.0,
            .ceara: 2688.0,
            .saoPaulo: 429.0,
            .minasGerais: 339.0
        ],
        .saoPaulo: [
            .alagoas: 2140.0,
            .bahia: 1942.0,
            .ceara: 2760.0,
            .rioDeJaneiro: 429.0,
            .minasGerais: 586.0
        ],
        .minasGerais: [
            .alagoas: 1620.0,
            .bahia: 1370.0,
            .ceara: 2230.0,
            .rioDeJaneiro: 339.0,
            .saoPaulo: 586.0
        ]
    ]
    
    func distance(to destination: State) -> Double? {
        return State.distances[self]?[destination]
    }
}

let reservationSystem = ReservationSystem()

reservationSystem.addReservation(transport: .airplane, ticketID: "A123", passengerName: "Gabriela Santos", origin: .alagoas, destination: .saoPaulo)
reservationSystem.addReservation(transport: .train, ticketID: "T456", passengerName: "Rafaela Aparecida", origin: .ceara, destination: .rioDeJaneiro)
reservationSystem.addReservation(transport: .bus, ticketID: "B789", passengerName: "Guilherme Lopes", origin: .bahia, destination: .minasGerais)

print("\nList all reservations:")
reservationSystem.listAllReservations()

print("\nSearch for airplane reservations:")
reservationSystem.searchReservations(transport: .airplane)
