import Foundation
import CoreLocation

// MARK: - Bar Information

struct BarInfo {
    static let shared = BarInfo()

    let name = "The Speaker Pub"
    let tagline = "Английский паб в Москве"
    let address = "Москва, ул. Покровка, д. 48, стр. 1, 1 этаж"
    let shortAddress = "ул. Покровка, 48"
    let metro = "Красные Ворота"
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

    let aboutText = """
    The Speaker Pub — настоящий британский паб в самом сердце Москвы на Покровке. \
    Не копия английского паба, а его вдумчивая интерпретация: \
    каск эли прямо из бочки, широкая коллекция виски, авторские коктейли \
    и честная пабная кухня — от фиш-энд-чипс до английских пирогов. \
    Тёмное дерево, кирпичные стены, винил на вертушках и дартс.
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
            description: "Командный квиз с призами. 1 место — 5000 ₽, 2 место — 3000 ₽, 3 место — 1000 ₽ сертификатами бара.",
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
