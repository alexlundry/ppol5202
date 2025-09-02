# geocoding every New Jersey eatery Guy Fieri has visited for 'Diners, Drive-ins and Dives'
# https://www.northjersey.com/story/entertainment/dining/2024/08/09/every-nj-eatery-guy-fieri-visited-for-diners-drive-ins-and-dives/74674993007/

nj_diners <- tribble(
  ~diner_name, ~city,
  "Tick Tock Diner", "Clifton",
  "Bayway Diner", "Linden",
  "Brownstone Diner & Pancake Factory", "Jersey City",
  "White Manna", "Hackensack",
  "Hightstown Diner", "Hightstown",
  "Jefferson Diner", "Lake Hopatcong",
  "Mustache Bill's Diner", "Barnegat Light",
  "The Ritz Diner", "Livingston",
  "Skylark Diner & Lounge", "Edison",
  "10th Avenue Burrito Co", "Belmar",
  "George's Place", "Cape May",
  "Quahog's Seafood Shack", "Stone Harbor",
  "Maui's Dog House", "Wildwood",
  "La Isla Restaurant", "Hoboken",
  "Marie's Italian Specialties", "Chatham Township",
  "Ernest and Son", "Brigantine",
  "Oyster Creek Inn Restaurant and Boat Bar", "Leeds Point",
  "Kelsey & Kim's Southern Cafe", "Atlantic City",
  "The Anchorage Tavern Restaurant", "Somers Point",
  "The Grilled Cheese & Crab Cake Co", "Somers Point",
  "Carluccio's Coal Fired Pizza", "Northfield",
  "Piccini Wood Fired Brick Oven Pizza", "Ocean City",
  "Sam's Rialto Bar & Grill", "Pleasantville",
  "Vagabond Kitchen & Tap House", "Atlantic City",
  "Jammin' Crepes", "Princeton",
  "Jersey Girl Cafe", "Hamilton Township",
  "Dolce & Clemente's", "Robbinsville",
  "Bagel Street Grill", "Plainsboro Township",
  "Rocky Hill Inn & Tavern", "Rocky Hill",
  "Vincentown Diner", "Southampton",
  "Haldi Chowk Authentic Indian", "Middletown Township",
  "Turf Surf & Earth", "Somerville",
  "The Chubby Pickle", "Highlands",
  "Big Pinks BBQ", "Bridgewater Township",
  "Moo Yai Thai Restaurant", "Sea Bright",
  "Joe's Meat Market", "South Bound Brook",
  "Cave Bistro", "Avon-By-The-Sea"
)

# custom NJ regions
north <- c("Bergen", "Essex", "Hudson", "Morris", "Passaic", "Sussex", "Warren" )
central <- c("Hunterdon", "Mercer", "Middlesex", "Somerset", "Union")
south <- c("Burlington", "Camden", "Cumberland", "Gloucester", "Salem")
shore <- c("Atlantic", "Cape May", "Monmouth", "Ocean")
