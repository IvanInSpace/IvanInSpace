import Foundation
import CoreLocation

// MARK: - Bar Information

struct BarInfo {
    static let shared = BarInfo()

    let name = "The Speaker Pub"
    let tagline = "Бар"
    let address = "Москва, ул. Покровка, дом 48"
    let phone = "+7 (926) 387-11-88"
    let phoneURL = URL(string: "tel:+79263871188")!
    let website = URL(string: "https://speakerpub.ru")!
    let coordinate = CLLocationCoordinate2D(latitude: 55.7610, longitude: 37.6530)

    let workingHours: [(day: String, hours: String)] = [
        ("Пн–Чт", "15:00–01:00"),
        ("Пт", "15:00–03:00"),
        ("Сб", "13:00–03:00"),
        ("Вс", "13:00–01:00")
    ]

    let aboutText = """
    The Speaker Pub — настоящий британский паб в самом сердце Москвы на Покровке. \
    Каск эли прямо из бочки, широкая коллекция виски, авторские коктейли \
    и честная пабная кухня — от фиш-энд-чипс до английских пирогов. \
    Уютная атмосфера, живая музыка и крафтовое пиво ждут вас каждый день.
    """

    let features = [
        "Каск эли из бочки",
        "30+ сортов виски",
        "Авторские коктейли",
        "Британская кухня",
        "Спортивные трансляции",
        "Живая музыка"
    ]
}
