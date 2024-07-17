const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

// Ülke ve hizmet verileri
const europeCountries = {
  'Turkey': 'Türkiye',
  'Germany': 'Almanya',
  'France': 'Fransa',
  'Italy': 'İtalya',
  'Spain': 'İspanya',
  'Netherlands': 'Hollanda',
  'Belgium': 'Belçika',
  'Austria': 'Avusturya',
  'Switzerland': 'İsviçre',
  'Sweden': 'İsveç',
  'Norway': 'Norveç',
  'Denmark': 'Danimarka',
  'Finland': 'Finlandiya',
  'Poland': 'Polonya',
  'Czech Republic': 'Çek Cumhuriyeti',
  'Hungary': 'Macaristan',
  'Portugal': 'Portekiz',
  'Greece': 'Yunanistan',
  'Ireland': 'İrlanda',
  'Romania': 'Romanya',
  'Bulgaria': 'Bulgaristan',
  'Croatia': 'Hırvatistan',
  'Slovakia': 'Slovakya',
  'Slovenia': 'Slovenya',
  'Estonia': 'Estonya',
  'Latvia': 'Letonya',
  'Lithuania': 'Litvanya',
  'Luxembourg': 'Lüksemburg',
  'Malta': 'Malta',
  'Cyprus': 'Kıbrıs',
  'Iceland': 'İzlanda',
  'Liechtenstein': 'Lihtenştayn',
  'Monaco': 'Monako',
  'Andorra': 'Andorra',
  'San Marino': 'San Marino',
  'Vatican': 'Vatikan'
};

const servicesList = {
  'Transportation': 'Ulaşım',
  'Public Transport': {
    'name': 'Toplu Taşıma',
    'subcategories': {
      'Bus': 'Otobüs',
      'Metro': 'Metro',
      'Train': 'Tren',
      'Tram': 'Tramvay',
      'Ferry': 'Feribot',
      'Airplane': 'Uçak'
    },
  },
  'Market': {
    'name': 'Market',
    'subcategories': {
      'Milk': 'Süt',
      'Bread': 'Ekmek',
      'Egg': 'Yumurta',
      'Fruit': 'Meyve',
      'Vegetable': 'Sebze',
      'Meat': 'Et',
      'Cheese': 'Peynir',
      'Yogurt': 'Yoğurt',
      'Butter': 'Tereyağı',
      'Toilet Paper': 'Tuvalet Kağıdı',
      'Detergent': 'Deterjan',
      'Shampoo': 'Şampuan',
      'Conditioner': 'Saç Kremi',
      'Toothpaste': 'Diş Macunu',
      'Toothbrush': 'Diş Fırçası',
      'Soap': 'Sabun',
      'Body Wash': 'Vücut Yıkama Jeli',
      'Hand Sanitizer': 'El Dezenfektanı',
      'Disinfectant Wipes': 'Dezenfektan Mendil',
      'Paper Towels': 'Kağıt Havlu',
      'Facial Tissue': 'Yüz Mendili',
      'Napkins': 'Peçete',
      'Aluminum Foil': 'Alüminyum Folyo',
      'Plastic Wrap': 'Streç Film',
      'Sandwich Bags': 'Sandviç Poşeti',
      'Trash Bags': 'Çöp Torbası',
      'Laundry Detergent': 'Çamaşır Deterjanı',
      'Fabric Softener': 'Yumuşatıcı',
      'Dish Soap': 'Bulaşık Deterjanı',
      'Sponges': 'Sünger',
      'Cleaning Spray': 'Temizlik Spreyi',
      'Bleach': 'Çamaşır Suyu',
      'Glass Cleaner': 'Cam Temizleyici',
      'Floor Cleaner': 'Yer Temizleyici',
      'Air Freshener': 'Oda Spreyi',
      'Batteries': 'Piller',
      'Light Bulbs': 'Ampuller',
      'Matches': 'Kibrit',
      'Lighter': 'Çakmak',
      'Canned Beans': 'Konserve Fasulye',
      'Canned Corn': 'Konserve Mısır',
      'Canned Tomatoes': 'Konserve Domates',
      'Pasta': 'Makarna',
      'Rice': 'Pirinç',
      'Flour': 'Un',
      'Sugar': 'Şeker',
      'Salt': 'Tuz',
      'Pepper': 'Karabiber',
      'Olive Oil': 'Zeytinyağı',
      'Vegetable Oil': 'Ayçiçek Yağı',
      'Vinegar': 'Sirke',
      'Soy Sauce': 'Soya Sosu',
      'Ketchup': 'Ketçap',
      'Mustard': 'Hardal',
      'Mayonnaise': 'Mayonez',
      'Hot Sauce': 'Acı Sos',
      'BBQ Sauce': 'BBQ Sosu',
      'Honey': 'Bal',
      'Jam': 'Reçel',
      'Peanut Butter': 'Fıstık Ezmesi',
      'Coffee': 'Kahve',
      'Tea': 'Çay',
      'Juice': 'Meyve Suyu',
      'Soda': 'Gazlı İçecek',
      'Water': 'Su',
      'Sparkling Water': 'Soda',
      'Beer': 'Bira',
      'Wine': 'Şarap',
      'Liquor': 'Alkollü İçecek',
      'Frozen Vegetables': 'Dondurulmuş Sebzeler',
      'Frozen Meals': 'Dondurulmuş Yemekler',
      'Ice Cream': 'Dondurma',
      'Pizza': 'Pizza',
      'Chips': 'Cips',
      'Crackers': 'Kraker',
      'Cookies': 'Kurabiye',
      'Cereal': 'Mısır Gevreği',
      'Granola Bars': 'Granola Barları',
      'Buns': 'Sandviç Ekmeği',
      'Bagels': 'Bagel',
      'Muffins': 'Muffin',
      'Cake': 'Pasta',
      'Pie': 'Turta',
      'Cupcakes': 'Kek',
      'Donuts': 'Donut',
      'Candy': 'Şeker',
      'Chocolate': 'Çikolata',
      'Gum': 'Sakız',
      'Mints': 'Nane Şekeri'
    },
  },
  'Restaurant': 'Restoran',
  'Accommodation': {
    'name': 'Konaklama',
    'subcategories': {
      'Hotel': 'Otel',
      'Rental House': 'Kiralık Ev',
      'Hostel': 'Hostel',
      'Pension': 'Pansiyon',
      'Camp': 'Kamp'
    },
  },
  'Museum': 'Müze',
  'Fuel': 'Yakıt',
  'Rental': {
    'name': 'Kiralama',
    'subcategories': {
      'Car Rental': 'Araba Kiralama',
      'Bicycle Rental': 'Bisiklet Kiralama',
      'Scooter Rental': 'Scooter Kiralama'
    },
  },
  'Currency Exchange': 'Döviz',
  'Massage': 'Masaj',
  'Clothing': {
    'name': 'Kıyafet',
    'subcategories': {
      'T-shirt': 'Tişört',
      'Pants': 'Pantolon',
      'Dress': 'Elbise',
      'Jacket': 'Ceket',
      'Shoes': 'Ayakkabı',
      'Hat': 'Şapka',
      'Scarf': 'Atkı',
      'Gloves': 'Eldiven',
      'Belt': 'Kemer',
      'Sunglasses': 'Güneş Gözlüğü',
      'Socks': 'Çorap',
      'Underpants': 'Külot',
      'Bra': 'Sütyen',
      'Undershirt': 'Atlet',
      'Tracksuit': 'Eşofman',
      'Sports Shorts': 'Spor Şortu',
      'Sports Bra': 'Spor Sütyeni',
      'Running Shoes': 'Koşu Ayakkabısı',
      'Coat': 'Mont',
      'Raincoat': 'Yağmurluk',
      'Blazer': 'Blazer Ceket',
      'Trench Coat': 'Trençkot',
      'Suit': 'Takım Elbise',
      'Dress Shirt': 'Gömlek',
      'Tie': 'Kravat',
      'Blouse': 'Bluz'
    }
  },
  'Taxi': 'Taksi',
  'Parking': 'Otopark',
  'Coffee Shop': 'Kafe',
  'Fast Food': 'Fast Food',
  'Cinema': 'Sinema',
  'Theater': 'Tiyatro',
  'Concert': 'Konser',
  'Spa': 'Spa',
  'Gym': 'Spor Salonu',
  'Amusement Park': 'Lunapark',
  'Pharmacy': 'Eczane',
  'Hospital': 'Hastane',
  'Airport Shuttle': 'Havaalanı Servisi',
  'Tour Guide': 'Tur Rehberi',
  'Internet': 'İnternet',
  'Phone Card': 'Telefon Kartı',
  'Laundry': 'Çamaşırhane',
  'Dry Cleaning': 'Kuru Temizleme',
};

// Ülkeleri Listeleme
app.get('/api/countries', (req, res) => {
  const countryList = Object.keys(europeCountries).map(code => ({
    code,
    name: europeCountries[code]
  }));
  res.json({ countries: countryList });
});

// Kategorileri Listeleme
app.get('/api/categories', (req, res) => {
  const categoryList = Object.keys(servicesList).map(key => ({
    name: key,
    subcategories: servicesList[key].subcategories ? Object.keys(servicesList[key].subcategories).map(subKey => ({
      name: subKey,
      localizedName: servicesList[key].subcategories[subKey]
    })) : []
  }));
  res.json({ categories: categoryList });
});

// Fiyat Arama
app.get('/api/prices', (req, res) => {
  const { country, category, subcategory } = req.query;

  if (!country || !category) {
    return res.status(400).json({ error: 'Ülke ve kategori belirtilmelidir.' });
  }

  // Bu örnekte sabit bir fiyat listesi dönüyoruz.
  const prices = [
    {
      country: europeCountries[country],
      category,
      subcategory,
      priceUSD: 1.2,
      priceEUR: 1.1,
      priceLocal: 10.5,
      currency: "TRY",
      lastUpdated: new Date().toISOString().split('T')[0]
    }
  ];

  res.json({ prices });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
