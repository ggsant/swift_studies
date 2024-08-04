protocol TransportStrategy {
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket
    func calculateTicketPrice(origin: State, destination: State) -> Double
}

class AirplaneTransport : TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard var distance = origin.distance(from: origin, to: destination) else { return 0.0 }
        var transportFactor = 0.3
        var tax = 100.0
        var price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket {
        var price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName,  origin: origin, destination: destination, transport: Transport.airplane, price:price)
    }
}

class TrainTransport : TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard var distance = origin.distance(from: origin, to: destination) else { return 0.0 }
        var transportFactor = 0.2
        var tax = 50.0
        var price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String,  origin: State, destination: State) -> Ticket {
        var price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName, origin: origin, destination: destination, transport: Transport.train, price: price)
    }
}

class BusTransport : TransportStrategy {
    func calculateTicketPrice(origin: State, destination: State) -> Double {
        guard var distance = origin.distance(from: origin, to: destination) else { return 0.0 }
        var transportFactor = 0.1
        var tax = 30.0
        var price = (distance * transportFactor) + tax
        return price
    }
    
    func book(ticketID: String, passengerName: String,  origin: State, destination: State) -> Ticket {
        var price = calculateTicketPrice(origin: origin, destination: destination)
        return Ticket(ticketId: ticketID, passengerName: passengerName, origin: origin, destination: destination, transport: Transport.bus, price: price)
    }
}

class TransportContext{
    private var strategy : TransportStrategy?
    
    func setTransportStrategy(strategy: TransportStrategy){
        self.strategy = strategy
    }
    
    func executeBooking(ticketID: String, passengerName: String, origin: State, destination: State) -> Ticket? {
        guard let strategy = strategy else {
            print("Transport stratefy not set.")
            return nil
        }
        
        return strategy.book(ticketID: ticketID, passengerName: passengerName, origin: origin, destination: destination)
    }
}

enum Transport : String{
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
        get {
            return "A passagem foi reservada com sucesso. \n Id: \(ticketId)  \n Origem: \(origin.rawValue)  \n Destino: \(destination.rawValue)  \n Transporte: \(transport.rawValue)  \n Passageiro: \(passengerName) \n Valor total: \(price)."
        }
    }
    
    var info: String {
        get {
            return "Informações da passagem: \n Id: \(ticketId)  \n Origem: \(origin.rawValue)  \n Destino: \(destination.rawValue)  \n Transporte: \(transport.rawValue)  \n Passageiro: \(passengerName) \n Valor total: \(price)."
        }
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
        
        let newTicket = context.executeBooking(ticketID: ticketID, passengerName: passengerName, origin: origin, destination: destination)
        
        if reservations[transport] == nil {
            reservations[transport] = []
        }
        
        if let ticket = newTicket {
            reservations[transport]?.append(ticket)
            print(ticket.successMessage)
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
    case espiritoSanto = "Espírito Santo"
    case maranhao = "Maranhão"
    case paraiba = "Paraíba"
    case pernambuco = "Pernambuco"
    case piaui = "Piauí"
    case rioDeJaneiro = "Rio de Janeiro"
    case rioGrandeDoNorte = "Rio Grande do Norte"
    case saoPaulo = "São Paulo"
    case sergipe = "Sergipe"
    case minasGerais = "Minas Gerais"

    private static let distances: [State: [State: Double]] = [
        .alagoas: [
            .bahia: 875.0,
            .ceara: 1037.0,
            .espiritoSanto: 1630.0,
            .maranhao: 1648.0,
            .paraiba: 266.0,
            .pernambuco: 256.0,
            .piaui: 1004.0,
            .rioDeJaneiro: 1950.0,
            .rioGrandeDoNorte: 494.0,
            .saoPaulo: 2140.0,
            .sergipe: 285.0,
            .minasGerais: 1620.0
        ],
        .bahia: [
            .alagoas: 875.0,
            .ceara: 1213.0,
            .espiritoSanto: 1202.0,
            .maranhao: 1067.0,
            .paraiba: 1237.0,
            .pernambuco: 969.0,
            .piaui: 1135.0,
            .rioDeJaneiro: 1530.0,
            .rioGrandeDoNorte: 1347.0,
            .saoPaulo: 1942.0,
            .sergipe: 324.0,
            .minasGerais: 1370.0
        ],
        .ceara: [
            .alagoas: 1037.0,
            .bahia: 1213.0,
            .espiritoSanto: 1992.0,
            .maranhao: 690.0,
            .paraiba: 702.0,
            .pernambuco: 800.0,
            .piaui: 579.0,
            .rioDeJaneiro: 2688.0,
            .rioGrandeDoNorte: 553.0,
            .saoPaulo: 2760.0,
            .sergipe: 1070.0,
            .minasGerais: 2230.0
        ],
        .espiritoSanto: [
            .alagoas: 1630.0,
            .bahia: 1202.0,
            .ceara: 1992.0,
            .maranhao: 1868.0,
            .paraiba: 1876.0,
            .pernambuco: 1792.0,
            .piaui: 1941.0,
            .rioDeJaneiro: 521.0,
            .rioGrandeDoNorte: 2162.0,
            .saoPaulo: 883.0,
            .sergipe: 1407.0,
            .minasGerais: 524.0
        ],
        .maranhao: [
            .alagoas: 1648.0,
            .bahia: 1067.0,
            .ceara: 690.0,
            .espiritoSanto: 1868.0,
            .paraiba: 1327.0,
            .pernambuco: 1455.0,
            .piaui: 510.0,
            .rioDeJaneiro: 2262.0,
            .rioGrandeDoNorte: 1574.0,
            .saoPaulo: 2832.0,
            .sergipe: 1410.0,
            .minasGerais: 2180.0
        ],
        .paraiba: [
            .alagoas: 266.0,
            .bahia: 1237.0,
            .ceara: 702.0,
            .espiritoSanto: 1876.0,
            .maranhao: 1327.0,
            .pernambuco: 120.0,
            .piaui: 837.0,
            .rioDeJaneiro: 2394.0,
            .rioGrandeDoNorte: 188.0,
            .saoPaulo: 2786.0,
            .sergipe: 769.0,
            .minasGerais: 2000.0
        ],
        .pernambuco: [
            .alagoas: 256.0,
            .bahia: 969.0,
            .ceara: 800.0,
            .espiritoSanto: 1792.0,
            .maranhao: 1455.0,
            .paraiba: 120.0,
            .piaui: 1131.0,
            .rioDeJaneiro: 2408.0,
            .rioGrandeDoNorte: 296.0,
            .saoPaulo: 2786.0,
            .sergipe: 510.0,
            .minasGerais: 1940.0
        ],
        .piaui: [
            .alagoas: 1004.0,
            .bahia: 1135.0,
            .ceara: 579.0,
            .espiritoSanto: 1941.0,
            .maranhao: 510.0,
            .paraiba: 837.0,
            .pernambuco: 1131.0,
            .rioDeJaneiro: 2404.0,
            .rioGrandeDoNorte: 1114.0,
            .saoPaulo: 2818.0,
            .sergipe: 1218.0,
            .minasGerais: 2060.0
        ],
        .rioDeJaneiro: [
            .alagoas: 1950.0,
            .bahia: 1530.0,
            .ceara: 2688.0,
            .espiritoSanto: 521.0,
            .maranhao: 2262.0,
            .paraiba: 2394.0,
            .pernambuco: 2408.0,
            .piaui: 2404.0,
            .rioGrandeDoNorte: 2582.0,
            .saoPaulo: 429.0,
            .sergipe: 1736.0,
            .minasGerais: 339.0
        ],
        .rioGrandeDoNorte: [
            .alagoas: 494.0,
            .bahia: 1347.0,
            .ceara: 553.0,
            .espiritoSanto: 2162.0,
            .maranhao: 1574.0,
            .paraiba: 188.0,
            .pernambuco: 296.0,
            .piaui: 1114.0,
            .rioDeJaneiro: 2582.0,
            .saoPaulo: 2792.0,
            .sergipe: 995.0,
            .minasGerais: 2190.0
        ],
        .saoPaulo: [
            .alagoas: 2140.0,
            .bahia: 1942.0,
            .ceara: 2760.0,
            .espiritoSanto: 883.0,
            .maranhao: 2832.0,
            .paraiba: 2786.0,
            .pernambuco: 2786.0,
            .piaui: 2818.0,
            .rioDeJaneiro: 429.0,
            .rioGrandeDoNorte: 2792.0,
            .sergipe: 2134.0,
            .minasGerais: 586.0
        ],
        .sergipe: [
            .alagoas: 285.0,
            .bahia: 324.0,
            .ceara: 1070.0,
            .espiritoSanto: 1407.0,
            .maranhao: 1410.0,
            .paraiba: 769.0,
            .pernambuco: 510.0,
            .piaui: 1218.0,
            .rioDeJaneiro: 1736.0,
            .rioGrandeDoNorte: 995.0,
            .saoPaulo: 2134.0,
            .minasGerais: 1190.0
        ],
        .minasGerais: [
            .alagoas: 1620.0,
            .bahia: 1370.0,
            .ceara: 2230.0,
            .espiritoSanto: 524.0,
            .maranhao: 2180.0,
            .paraiba: 2000.0,
            .pernambuco: 1940.0,
            .piaui: 2060.0,
            .rioDeJaneiro: 339.0,
            .rioGrandeDoNorte: 2190.0,
            .saoPaulo: 586.0,
            .sergipe: 1190.0
        ]
    ]
    
    func distance(from origin: State, to destination: State) -> Double? {
        return State.distances[origin]?[destination]
    }
}

let reservationSystem = ReservationSystem()

reservationSystem.addReservation(transport: Transport.airplane, ticketID: "A123", passengerName: "Gabriela Santos", origin: State.alagoas,destination: State.saoPaulo)
reservationSystem.addReservation(transport: Transport.train, ticketID: "T456", passengerName: "Rafaela Aparecida",  origin: State.sergipe, destination: State.rioDeJaneiro)
reservationSystem.addReservation(transport: Transport.bus, ticketID: "B789", passengerName: "Guilherme Lopes",  origin: State.rioGrandeDoNorte, destination: State.minasGerais)

print("\nList all reservations:")
reservationSystem.listAllReservations()

print("\nSearch for airplane reservations:")
reservationSystem.searchReservations(transport: Transport.airplane)
