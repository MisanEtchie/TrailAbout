//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let locations: [Location] = [
        Location(
            name: "Colosseum",
            cityName: "Rome",
            region: .southernEurope,
            type: .monument,
            coordinates: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            description: "The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy, just east of the Roman Forum. It is the largest ancient amphitheatre ever built, and is still the largest standing amphitheatre in the world today, despite its age.",
            imageNames: [
                "rome-colosseum-1",
                "rome-colosseum-2",
                "rome-colosseum-3",
            ],
            link: "https://en.wikipedia.org/wiki/Colosseum"),
        Location(
            name: "Pantheon",
            cityName: "Rome",
            region: .southernEurope,
            type: .historicalSite,
            coordinates: CLLocationCoordinate2D(latitude: 41.8986, longitude: 12.4769),
            description: "The Pantheon is a former Roman temple and since the year 609 a Catholic church, in Rome, Italy, on the site of an earlier temple commissioned by Marcus Agrippa during the reign of Augustus.",
            imageNames: [
                "rome-pantheon-1",
                "rome-pantheon-2",
                "rome-pantheon-3",
            ],
            link: "https://en.wikipedia.org/wiki/Pantheon,_Rome"),
        Location(
            name: "Trevi Fountain",
            cityName: "Rome",
            region: .southernEurope,
            type: .tourism,
            coordinates: CLLocationCoordinate2D(latitude: 41.9009, longitude: 12.4833),
            description: "The Trevi Fountain is a fountain in the Trevi district in Rome, Italy, designed by Italian architect Nicola Salvi and completed by Giuseppe Pannini and several others. Standing 26.3 metres high and 49.15 metres wide, it is the largest Baroque fountain in the city and one of the most famous fountains in the world.",
            imageNames: [
                "rome-trevifountain-1",
                "rome-trevifountain-2",
                "rome-trevifountain-3",
            ],
            link: "https://en.wikipedia.org/wiki/Trevi_Fountain"),
        Location(
            name: "Eiffel Tower",
            cityName: "Paris",
            region: .westernEurope,
            type: .monument,
            coordinates: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
            description: "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower. Locally nicknamed 'La dame de fer', it was constructed from 1887 to 1889 as the centerpiece of the 1889 World's Fair and was initially criticized by some of France's leading artists and intellectuals for its design, but it has become a global cultural icon of France and one of the most recognizable structures in the world.",
            imageNames: [
                "paris-eiffeltower-1",
                "paris-eiffeltower-2",
            ],
            link: "https://en.wikipedia.org/wiki/Eiffel_Tower"),
        Location(
            name: "Louvre Museum",
            cityName: "Paris",
            region: .westernEurope,
            type: .cultural,
            coordinates: CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3376),
            description: "The Louvre, or the Louvre Museum, is the world's most-visited museum and a historic monument in Paris, France. It is the home of some of the best-known works of art, including the Mona Lisa and the Venus de Milo. A central landmark of the city, it is located on the Right Bank of the Seine in the city's 1st arrondissement.",
            imageNames: [
                "paris-louvre-1",
                "paris-louvre-2",
                "paris-louvre-3",
            ],
            link: "https://en.wikipedia.org/wiki/Louvre"),
        
        //
        //
        //
        Location(
                    name: "Lowell Observatory",
                    cityName: "Flagstaff",
                    region: .northernAmerica,
                    type: .tourism,
                    coordinates: CLLocationCoordinate2D(latitude: 35.2016, longitude: -111.6646),
                    description: "Lowell Observatory is an astronomical observatory in Flagstaff, Arizona, United States. The observatory is among the oldest in the United States and was designated a National Historic Landmark in 1965.",
                    imageNames: [
                        "paris-louvre-1",
                        "paris-louvre-2",
                        "paris-louvre-3",
                    ],
                    link: "https://lowell.edu"
                ),
                Location(
                    name: "Pyramids of Giza",
                    cityName: "Giza",
                    region: .northernAfrica,
                    type: .monument,
                    coordinates: CLLocationCoordinate2D(latitude: 29.9792, longitude: 31.1342),
                    description: "The Pyramids of Giza, located in Egypt, are ancient pyramid structures that were built as tombs for the country's Pharaohs. The complex includes the Great Pyramid, which is one of the Seven Wonders of the Ancient World.",
                    imageNames: [
                        "paris-louvre-1",
                        "paris-louvre-2",
                        "paris-louvre-3",
                    ],
                    link: "https://en.wikipedia.org/wiki/Giza_pyramid_complex"
                ),
                Location(
                    name: "Statue of Liberty",
                    cityName: "New York",
                    region: .northernAmerica,
                    type: .monument,
                    coordinates: CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445),
                    description: "The Statue of Liberty is a colossal neoclassical sculpture on Liberty Island in New York Harbor within New York City. The statue, designed by French sculptor Frédéric Auguste Bartholdi and built by Gustave Eiffel, was a gift from the people of France to the United States.",
                    imageNames: [
                        "paris-louvre-1",
                        "paris-louvre-2",
                        "paris-louvre-3",
                    ],
                    link: "https://en.wikipedia.org/wiki/Statue_of_Liberty"
                )
    ]
    
}
