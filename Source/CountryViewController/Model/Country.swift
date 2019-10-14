//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Erik Kamalov <ekamalov967@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

typealias Countries = [Country]

struct Country: Codable, Equatable {
    let pattern, mask, cc, nameEn: String
    let dialCode,nameRu: String
    
    enum CodingKeys: String, CodingKey {
        case pattern, mask, cc
        case nameEn = "name_en" 
        case dialCode = "dial_code"
        case nameRu = "name_ru"
    }
    
    var localizeName:String {
        if let languageCode = Locale.current.languageCode {
            return languageCode == "ru" ? self.nameRu : self.nameEn
        }
        return self.nameEn
    }
}

internal class CountryService {
    // MARK: - Attributes
    static let shared = CountryService()
    private var countries:Countries = []
    private var countriesDictionary:[(key: String, value: [Country])] = []
    
    // MARK: - Initializers
    private init()  {
        self.allCountries { (result) in
            switch result {
            case .success(let items):
                self.countries = items
                self.countriesDictionary = Dictionary(grouping: items, by: { String($0.localizeName.first ?? " " ) }).sorted { $0.0 < $1.0 }
            case .failure(let error): print(error)
            }
        }
    }
    
    func countriesByRelated(related: [String])-> [(key: String, value: [Country])] {
        let tmpRelated:[Country] = related.compactMap { cc in
            if let object = countries.filter({ $0.cc == cc }).first {
                return object
            }
            fatalError("can't find country by cc:\(cc), you can add your contry to CountryCodes.json in Resources group")
        }
        var tmpCountriesDictionary = countriesDictionary
        if tmpRelated.count > 0 {
            tmpCountriesDictionary.insert((key:"Related", value: tmpRelated), at: 0)
        }
        return tmpCountriesDictionary
    }
    
    func search(_ by:String) -> [(key: String, value: [Country])] {
        if by.count == 0 { return countriesDictionary }
        let filteredData = countries.filter { $0.localizeName.lowercased().contains(by.lowercased())}
        return [(key: filteredData.count > 0 ? "Result" : "Not found", value: filteredData)]
    }
    
    func localeCountry() -> Country? {
        let regionCode:String = Locale.current.regionCode ?? "US"
        return countries.filter { $0.cc == regionCode }.first
    }
    
    // MARK: - Parsers
    private func allCountries(completion:  @escaping (Result<Countries,Error>) -> Void) {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl)
                let res = try JSONDecoder().decode(Countries.self, from: data)
                completion(.success(res))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
