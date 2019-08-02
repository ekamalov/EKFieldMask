//
//  Country.swift
//  EKFieldMask
//
//  Created by Erik Kamalov on 6/29/19.
//  Copyright © 2019 Neuron. All rights reserved.
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
    static let shared = CountryService()
    private var countries:Countries = []
    private var countriesDictionary:[(key: String, value: [Country])] = []
    
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
        if tmpRelated.count > 0 {
            countriesDictionary.insert((key:"Related", value: tmpRelated), at: 0)
        }
        return countriesDictionary
    }
    
    func filter(_ by: @escaping (Country) -> Bool) -> [Country] {
        return countries.filter { by($0) }
    }
    
    func search(_ by:String) -> [(key: String, value: [Country])] {
        if by.count == 0 { return countriesDictionary }
        let filteredData = countries.filter { $0.localizeName.lowercased().contains(by.lowercased())}
        return [(key: filteredData.count > 0 ? "Result" : "Not found", value: filteredData)]
    }
    
    func localeCountry() -> Country? {
        return filter { $0.cc == Locale.current.regionCode}.first
    }
    
    func allCountries(completion:  @escaping (Result<Countries,Error>) -> Void) {
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
