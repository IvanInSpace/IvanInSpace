import Foundation
import CoreLocation

// MARK: - Bar Information

struct BarInfo {
    static let shared = BarInfo()

    let name = "The Speaker Pub"
    let tagline = "Английский паб в Москве"
    let address = "ул. Покровка, д. 48, стр. 1, 1 этаж"
    let shortAddress = "ул. Покровка, 48"
    let metro = "Курская / Красные ворота"
    let phone = "+7 (926) 387-11-88"
    let phoneURL = URL(string: "tel:+79263871188")!
    let website = URL(string: "https://speakerpub.ru")!
    let telegram = URL(string: "https://t.me/thespeakerpub")!
    let telegramHandle = "@thespeakerpub"
    let coordinate = CLLocationCoordinate2D(latitude: 55.7610, longitude: 37.6530)

    let workingHours: [(day: String, hours: String)] = [
        ("Пн–Чт", "12:00–00:00"),
        ("Пт–Сб", "12:00–05:00"),
        ("Вс", "12:00–00:00")
    ]

    // Schedule: (weekday range, open hour, close hour next-day-adjusted)
    private let schedule: [(days: ClosedRange<Int>, open: Int, close: Int)] = [
        (2...5, 12, 24),   // Пн–Чт: 12–00
        (6...7, 12, 29),   // Пт–Сб: 12–05 (29 = next day 05:00)
        (1...1, 12, 24)    // Вс: 12–00
    ]

    func currentStatus() -> (isOpen: Bool, closingTime: String) {
        let moscow = TimeZone(identifier: "Europe/Moscow")!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = moscow
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let hour = calendar.component(.hour, from: now)

        for entry in schedule where entry.days.contains(weekday) {
            let closeDisplay = entry.close > 24
                ? String(format: "%02d:00", entry.close - 24)
                : "00:00"
            if entry.close > 24 {
                if hour >= entry.open || hour < (entry.close - 24) {
                    return (true, closeDisplay)
                }
            } else {
                if hour >= entry.open { return (true, closeDisplay) }
            }
            return (false, String(format: "%02d:00", entry.open))
        }
        return (false, "12:00")
    }

    var yandexMapsURL: URL {
        URL(string: "yandexmaps://maps.yandex.ru/?pt=\(coordinate.longitude),\(coordinate.latitude)&z=17&text=The+Speaker+Pub")!
    }

    var yandexMapsWebURL: URL {
        URL(string: "https://yandex.ru/maps/?pt=\(coordinate.longitude),\(coordinate.latitude)&z=17&text=The+Speaker+Pub")!
    }

    let aboutText = """
    Speaker Pub — камерный британский паб с авторским интерьером \
    и хорошей пивной подборкой.

    Мы сделали место для встреч с друзьями, спокойных вечеров \
    и разговоров за баром. Темное дерево, винтажная мебель \
    и кирпичная кладка создают настроение без лишнего шума. \
    Проводим DJ-set'ы, Квизы, турниры по дартс и шахматам.

    Летом открываем террасу и угощаем блюдами, приготовленными на гриле.
    """

    let features = [
        "Каск эли из бочки",
        "30+ сортов виски",
        "Авторские коктейли",
        "Британская кухня",
        "Спортивные трансляции",
        "DJ-сеты на виниле",
        "Паб-квиз по понедельникам",
        "Дартс",
        "Dog-friendly",
        "Летняя терраса"
    ]

    let events: [BarEvent] = [
        BarEvent(
            title: "US Pub Quiz",
            day: "Каждый понедельник",
            description: "Командный квиз с призами.",
            icon: "brain.head.profile"
        ),
        BarEvent(
            title: "DJ Vinyl Set",
            day: "Пятница и суббота",
            description: "House, techno, afro, disco — только винил.",
            icon: "opticaldisc"
        ),
        BarEvent(
            title: "Спортивные трансляции",
            day: "По расписанию",
            description: "Лига Чемпионов, АПЛ, РПЛ и другие турниры на SKY Sport.",
            icon: "sportscourt"
        )
    ]
}

// MARK: - Bar Event

struct BarEvent: Identifiable {
    let id = UUID()
    let title: String
    let day: String
    let description: String
    let icon: String
}
