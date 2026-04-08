import Foundation

// MARK: - Complete Menu Data
// Reconstructed from provided menu images. All prices in rubles (₽).

enum MenuData {

    // MARK: - Top-Level Sections

    static let sections: [MenuSection] = [
        barSection,
        kitchenSection
    ]

    // MARK: - Bar Section

    static let barSection = MenuSection(
        name: "Бар",
        icon: "wineglass",
        categories: [
            draughtBeer,
            naturalWine,
            sparklingWine,
            whiteWine,
            redWine,
            cocktails,
            vermouthAndLiqueur,
            vodka,
            gin,
            cognacCalvados,
            irishWhiskey,
            scotchWhisky,
            singleMalt,
            americanWhisky,
            rum,
            tequila,
            softDrinks,
            hotDrinks
        ]
    )

    // MARK: - Kitchen Section

    static let kitchenSection = MenuSection(
        name: "Кухня",
        icon: "fork.knife",
        categories: [
            coldStarters,
            hotStarters,
            salads,
            soups,
            burgerAndMore,
            sandwiches,
            hotDishes,
            englishPies,
            desserts
        ]
    )

    // MARK: - Bar Categories

    static let draughtBeer = MenuCategory(
        name: "Разливное пиво",
        volumeInfo: "568/280 мл",
        items: [
            MenuItem(name: "Guinness", description: "Ирландский стаут", prices: [PriceOption(amount: 950, label: "568 мл"), PriceOption(amount: 500, label: "280 мл")]),
            MenuItem(name: "Fuller's ESB", description: "Английский биттер", prices: [PriceOption(amount: 900, label: "568 мл"), PriceOption(amount: 500, label: "280 мл")]),
            MenuItem(name: "Kilkenny", description: "Ирландский красный эль", prices: [PriceOption(amount: 900, label: "568 мл"), PriceOption(amount: 500, label: "280 мл")]),
            MenuItem(name: "Old Speckled Hen", description: "Английский пейл эль", prices: [PriceOption(amount: 850, label: "568 мл"), PriceOption(amount: 450, label: "280 мл")]),
            MenuItem(name: "Level Head", description: "Американский IPA", prices: [PriceOption(amount: 850, label: "568 мл"), PriceOption(amount: 450, label: "280 мл")]),
            MenuItem(name: "Maestro Nitro Lager", description: "Нитро лагер", prices: [PriceOption(amount: 750, label: "568 мл"), PriceOption(amount: 400, label: "280 мл")]),
            MenuItem(name: "Blanche de Brabant", description: "Бельгийское пшеничное", prices: [PriceOption(amount: 800, label: "568 мл"), PriceOption(amount: 450, label: "280 мл")]),
            MenuItem(name: "Queen Grace Cask Ale", description: "Каск эль", prices: [PriceOption(amount: 600, label: "568 мл"), PriceOption(amount: 350, label: "280 мл")]),
            MenuItem(name: "Speaker Golden Cask Ale", description: "Фирменный каск эль", prices: [PriceOption(amount: 600, label: "568 мл"), PriceOption(amount: 350, label: "280 мл")]),
            MenuItem(name: "Cider Magners", description: "Ирландский сидр", prices: [PriceOption(amount: 850, label: "568 мл"), PriceOption(amount: 450, label: "280 мл")]),
            MenuItem(name: "Безалкогольное пиво", description: nil, prices: [PriceOption(amount: 600, label: "568 мл"), PriceOption(amount: 350, label: "280 мл")]),
            MenuItem(name: "Velka Morava", description: "Чешский солод", prices: [PriceOption(amount: 550, label: "568 мл"), PriceOption(amount: 300, label: "280 мл")]),
            MenuItem(name: "Nisko", description: "Светлый лагер", prices: [PriceOption(amount: 650, label: "568 мл"), PriceOption(amount: 350, label: "280 мл")]),
            MenuItem(name: "Guest Cask Ale", description: "Гостевой каск эль — спрашивайте у бармена", prices: [])
        ]
    )

    static let naturalWine = MenuCategory(
        name: "Натуральное вино",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Riesling Rheingau", description: "Германия", prices: [PriceOption(amount: 950, label: "бокал"), PriceOption(amount: 4750, label: "бутылка")]),
            MenuItem(name: "Pinot Noir Schneider", description: "Германия", prices: [PriceOption(amount: 1100, label: "бокал"), PriceOption(amount: 5500, label: "бутылка")]),
            MenuItem(name: "Eschenhof Holzer", description: "Австрия", prices: [PriceOption(amount: 5500, label: "бутылка")])
        ]
    )

    static let sparklingWine = MenuCategory(
        name: "Игристое вино",
        volumeInfo: "150/750 мл",
        items: [
            MenuItem(name: "Prosecco Casa Defra", description: "Италия", prices: [PriceOption(amount: 750, label: "бокал"), PriceOption(amount: 3750, label: "бутылка")]),
            MenuItem(name: "Cremant", description: "Франция", prices: [PriceOption(amount: 6900, label: "бутылка")]),
            MenuItem(name: "Cava", description: "Испания", prices: [PriceOption(amount: 5500, label: "бутылка")])
        ]
    )

    static let whiteWine = MenuCategory(
        name: "Белое вино",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Sauvignon Blanc", description: nil, prices: [PriceOption(amount: 750, label: "бокал"), PriceOption(amount: 3750, label: "бутылка")]),
            MenuItem(name: "Pinot Grigio", description: nil, prices: [PriceOption(amount: 750, label: "бокал"), PriceOption(amount: 3750, label: "бутылка")]),
            MenuItem(name: "Поместье Голубицкое Пётнар Розе", description: "Россия", prices: [PriceOption(amount: 3000, label: "бутылка")])
        ]
    )

    static let redWine = MenuCategory(
        name: "Красное вино",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Carmenere", description: nil, prices: [PriceOption(amount: 750, label: "бокал"), PriceOption(amount: 3750, label: "бутылка")])
        ]
    )

    static let cocktails = MenuCategory(
        name: "Коктейли",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Negroni", description: "Джин, красный вермут, кампари", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Margarita", description: "Текила, трипл сек, лайм", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Aperol Spritz", description: "Аперол, просекко, содовая", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Campari Spritz", description: "Кампари, просекко, содовая", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Limoncello Spritz", description: "Лимончелло, просекко, содовая", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Whiskey Sour", description: "Виски, лимон, сахарный сироп", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Smokey Sour", description: "Копчёный виски, лимон, сироп", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Apple Sour", description: "Яблочный виски сауэр", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Rain Dog", description: "Авторский коктейль", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Bloody Mary", description: "Водка, томатный сок, специи", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Rose Collins", description: "Джин, розовая вода, лимон, содовая", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Michelada", description: "Пиво, лайм, соусы, специи", prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "G-Shot", description: "3 порции", prices: [PriceOption(amount: 1200, label: "3 шота")])
        ]
    )

    static let vermouthAndLiqueur = MenuCategory(
        name: "Вермуты, биттеры и ликёры",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Amaro Montenegro", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Fernet Branca", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Branca Menta", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Limoncello", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Jagermeister", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Fireball", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Nordes Rojo", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Shots", description: "Шот дня — спрашивайте у бармена", prices: [PriceOption(amount: 400, label: nil)])
        ]
    )

    static let vodka = MenuCategory(
        name: "Водка",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Beluga", description: nil, prices: [PriceOption(amount: 350, label: nil)]),
            MenuItem(name: "Beluga Gold", description: nil, prices: [PriceOption(amount: 600, label: nil)]),
            MenuItem(name: "Чистые Росы", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Schmidt", description: nil, prices: [PriceOption(amount: 350, label: nil)]),
            MenuItem(name: "Schnaps Wieser Williams", description: "Грушевый шнапс", prices: [PriceOption(amount: 600, label: nil)]),
            MenuItem(name: "Самогон", description: nil, prices: [PriceOption(amount: 400, label: nil)])
        ]
    )

    static let gin = MenuCategory(
        name: "Джин",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "135 East Hyogo", description: "Япония", prices: [PriceOption(amount: 590, label: nil)]),
            MenuItem(name: "Hendricks", description: "Шотландия", prices: [PriceOption(amount: 850, label: nil)]),
            MenuItem(name: "Nordes", description: "Испания", prices: [PriceOption(amount: 750, label: nil)])
        ]
    )

    static let cognacCalvados = MenuCategory(
        name: "Коньяк, Кальвадос",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Monnet VS", description: nil, prices: [PriceOption(amount: 650, label: nil)]),
            MenuItem(name: "Hine VSOP", description: nil, prices: [PriceOption(amount: 890, label: nil)]),
            MenuItem(name: "Boulard Grand Solage", description: "Кальвадос", prices: [PriceOption(amount: 990, label: nil)])
        ]
    )

    static let irishWhiskey = MenuCategory(
        name: "Ирландский виски",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Tullamore DEW", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Born Irish", description: nil, prices: [PriceOption(amount: 650, label: nil)]),
            MenuItem(name: "Bushmills", description: nil, prices: [PriceOption(amount: 450, label: nil)])
        ]
    )

    static let scotchWhisky = MenuCategory(
        name: "Шотландский виски",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Monkey Shoulder", description: "Бленд", prices: [PriceOption(amount: 690, label: nil)])
        ]
    )

    static let singleMalt = MenuCategory(
        name: "Сингл Молт",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Glenfiddich 12 yo", description: "Speyside", prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Glenfiddich 15 yo", description: "Speyside", prices: [PriceOption(amount: 1200, label: nil)]),
            MenuItem(name: "Glenkinchie 12 yo", description: "Lowlands", prices: [PriceOption(amount: 990, label: nil)]),
            MenuItem(name: "Bruichladdich Port Charlotte 10 yo", description: "Islay", prices: [PriceOption(amount: 1400, label: nil)]),
            MenuItem(name: "Balvenie Double Wood 12 yo", description: "Speyside", prices: [PriceOption(amount: 1200, label: nil)]),
            MenuItem(name: "Lagavulin 16 yo", description: "Islay, торфяной", prices: [PriceOption(amount: 1700, label: nil)]),
            MenuItem(name: "Laphroaig Quarter Cask", description: "Islay", prices: [PriceOption(amount: 1200, label: nil)]),
            MenuItem(name: "Laphroaig 10 yo", description: "Islay", prices: [PriceOption(amount: 1600, label: nil)]),
            MenuItem(name: "Torabhaig", description: "Isle of Skye", prices: [PriceOption(amount: 990, label: nil)]),
            MenuItem(name: "Auchentoshan American Oak", description: "Lowlands", prices: [PriceOption(amount: 890, label: nil)]),
            MenuItem(name: "Singleton 12 yo", description: nil, prices: [PriceOption(amount: 790, label: nil)]),
            MenuItem(name: "Aberlour 12 yo", description: "Speyside", prices: [PriceOption(amount: 990, label: nil)]),
            MenuItem(name: "Bowmore 12 yo", description: "Islay", prices: [PriceOption(amount: 890, label: nil)]),
            MenuItem(name: "Aberfeldy 12 yo", description: "Highlands", prices: [PriceOption(amount: 890, label: nil)])
        ]
    )

    static let americanWhisky = MenuCategory(
        name: "Американский виски",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Jim Beam White", description: "Бурбон", prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Bulleit", description: "Бурбон", prices: [PriceOption(amount: 650, label: nil)])
        ]
    )

    static let rum = MenuCategory(
        name: "Ром",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Plantation Gran Reserva Barbados", description: "Барбадос", prices: [PriceOption(amount: 490, label: nil)]),
            MenuItem(name: "Plantation Gran Reserva Guatemala", description: "Гватемала", prices: [PriceOption(amount: 590, label: nil)])
        ]
    )

    static let tequila = MenuCategory(
        name: "Текила и Мескаль",
        volumeInfo: "40 мл",
        items: [
            MenuItem(name: "Lokita Artesonal Blanco", description: nil, prices: [PriceOption(amount: 750, label: nil)]),
            MenuItem(name: "Mezcal", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Agavita", description: nil, prices: [PriceOption(amount: 450, label: nil)])
        ]
    )

    static let softDrinks = MenuCategory(
        name: "Безалкогольные напитки",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Coca-Cola", description: nil, prices: [PriceOption(amount: 350, label: nil)]),
            MenuItem(name: "Gardenist Tonic", description: nil, prices: [PriceOption(amount: 350, label: nil)]),
            MenuItem(name: "Wiz Juice", description: "Сок", prices: [PriceOption(amount: 240, label: nil)]),
            MenuItem(name: "Petroglyph", description: "Вода", prices: [PriceOption(amount: 390, label: "375 мл"), PriceOption(amount: 590, label: "750 мл")]),
            MenuItem(name: "Домашний лимонад", description: nil, prices: [PriceOption(amount: 350, label: nil)])
        ]
    )

    static let hotDrinks = MenuCategory(
        name: "Горячие напитки",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Эспрессо", description: nil, prices: [PriceOption(amount: 250, label: nil)]),
            MenuItem(name: "Капучино", description: nil, prices: [PriceOption(amount: 300, label: nil)]),
            MenuItem(name: "Американо", description: nil, prices: [PriceOption(amount: 250, label: nil)]),
            MenuItem(name: "Flat White", description: nil, prices: [PriceOption(amount: 330, label: nil)]),
            MenuItem(name: "Чай", description: nil, prices: [PriceOption(amount: 350, label: nil)])
        ]
    )

    // MARK: - Kitchen Categories

    static let coldStarters = MenuCategory(
        name: "Холодные закуски",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Маринованные яйца", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Маринованные черри", description: nil, prices: [PriceOption(amount: 350, label: nil)]),
            MenuItem(name: "Маринованные оливки", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Картофельные чипсы домашние", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Жареный миндаль", description: nil, prices: [PriceOption(amount: 390, label: nil)]),
            MenuItem(name: "Фисташки", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Джерки Speaker", description: "Фирменные", prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Джерки", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Тар-тар из говядины", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Паштет с конфитюром", description: nil, prices: [PriceOption(amount: 600, label: nil)]),
            MenuItem(name: "Пинчос с сельдью", description: nil, prices: [PriceOption(amount: 500, label: nil)]),
            MenuItem(name: "Пинчос со скумбрией", description: nil, prices: [PriceOption(amount: 500, label: nil)]),
            MenuItem(name: "Пестрая Вителло Тоннато", description: nil, prices: [PriceOption(amount: 650, label: nil)]),
            MenuItem(name: "Слабосолёный лосось", description: nil, prices: [PriceOption(amount: 850, label: nil)]),
            MenuItem(name: "Мясная тарелка", description: nil, prices: [PriceOption(amount: 900, label: nil)])
        ]
    )

    static let hotStarters = MenuCategory(
        name: "Горячие закуски",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Гренки с соусом Блю-Чиз", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Картофель фри с пармезаном", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Куриные крылья Buffalo", description: nil, prices: [PriceOption(amount: 850, label: nil)]),
            MenuItem(name: "Куриные крылья BBQ", description: nil, prices: [PriceOption(amount: 850, label: nil)]),
            MenuItem(name: "Куриные стрипсы", description: nil, prices: [PriceOption(amount: 590, label: nil)]),
            MenuItem(name: "Сырные шарики", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Фиш & Чипс", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Креветки в соусе Ким-Чи", description: "Жареные", prices: [PriceOption(amount: 1100, label: nil)]),
            MenuItem(name: "Креветки с соусом Чипотле", description: "Отварные", prices: [PriceOption(amount: 1190, label: nil)]),
            MenuItem(name: "Креветки Темпура", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Начос Чили", description: nil, prices: [PriceOption(amount: 790, label: nil)]),
            MenuItem(name: "Батат фри с соусом Айоли", description: nil, prices: [PriceOption(amount: 650, label: nil)]),
            MenuItem(name: "Горячий Чечил", description: nil, prices: [PriceOption(amount: 450, label: nil)]),
            MenuItem(name: "Яйцо По-Шотландски", description: nil, prices: [PriceOption(amount: 790, label: nil)])
        ]
    )

    static let salads = MenuCategory(
        name: "Салаты",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Салат с сёмгой", description: nil, prices: [PriceOption(amount: 850, label: nil)]),
            MenuItem(name: "Салат с ростбифом", description: nil, prices: [PriceOption(amount: 780, label: nil)]),
            MenuItem(name: "Салат с курицей Карри", description: nil, prices: [PriceOption(amount: 750, label: nil)])
        ]
    )

    static let soups = MenuCategory(
        name: "Супы",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Томатный суп", description: nil, prices: [PriceOption(amount: 590, label: nil)]),
            MenuItem(name: "Похлёбка с ростбифом", description: nil, prices: [PriceOption(amount: 690, label: nil)])
        ]
    )

    static let burgerAndMore = MenuCategory(
        name: "Бургеры",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Бургер с говядиной", description: nil, prices: [PriceOption(amount: 900, label: nil)]),
            MenuItem(name: "Кесадилья с курицей", description: nil, prices: [PriceOption(amount: 790, label: nil)])
        ]
    )

    static let sandwiches = MenuCategory(
        name: "Сэндвичи",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Сэндвич с курицей", description: nil, prices: [PriceOption(amount: 750, label: nil)]),
            MenuItem(name: "Сэндвич с ростбифом", description: nil, prices: [PriceOption(amount: 790, label: nil)]),
            MenuItem(name: "Сэндвич с тунцом", description: nil, prices: [PriceOption(amount: 790, label: nil)]),
            MenuItem(name: "Сэндвич с пастрами", description: nil, prices: [PriceOption(amount: 850, label: nil)])
        ]
    )

    static let hotDishes = MenuCategory(
        name: "Горячие блюда",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Шницель Гольштейн с яйцом", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Кордон Блю", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Бифштекс с яйцом", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Карривурст", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Бангерс & Мэш", description: nil, prices: [PriceOption(amount: 800, label: nil)]),
            MenuItem(name: "Щёки говяжьи с пюре", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Бефстроганов из говядины", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Утиная ножка", description: nil, prices: [PriceOption(amount: 950, label: nil)]),
            MenuItem(name: "Рёбра горячего копчения", description: nil, prices: [PriceOption(amount: 1200, label: nil)])
        ]
    )

    static let englishPies = MenuCategory(
        name: "Английские пироги",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Пирог с говядиной", description: nil, prices: [PriceOption(amount: 890, label: nil)]),
            MenuItem(name: "Пирог с курицей", description: nil, prices: [PriceOption(amount: 790, label: nil)]),
            MenuItem(name: "Пирог с рыбой", description: nil, prices: [PriceOption(amount: 890, label: nil)]),
            MenuItem(name: "Пирог с чоризо и чеддером", description: nil, prices: [PriceOption(amount: 890, label: nil)])
        ]
    )

    static let desserts = MenuCategory(
        name: "Десерты",
        volumeInfo: nil,
        items: [
            MenuItem(name: "Баскский чизкейк", description: nil, prices: [PriceOption(amount: 550, label: nil)]),
            MenuItem(name: "Стики Тоффи", description: nil, prices: [PriceOption(amount: 550, label: nil)])
        ]
    )
}
