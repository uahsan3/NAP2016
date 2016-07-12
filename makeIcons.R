# Define icons for all the map elements for NAP Housing Scout

icon_folder <- paste(getwd(), 'icons', sep = '/')

aptIcon <- makeIcon(
  iconUrl = paste(icon_folder, "apartment-3.png", sep = '/'),
  iconWidth = 40, iconHeight = 55,
  iconAnchorX = 5, iconAnchorY = 20
)

shopIcon <- makeIcon(
  iconUrl = paste(icon_folder, "shopping_cart.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

ddsIcon <- makeIcon(
  iconUrl = paste(icon_folder, "DMV.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

ssnIcon <- makeIcon(
  iconUrl = paste(icon_folder, "SSN.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

dfacsIcon <- makeIcon(
  iconUrl = paste(icon_folder, "dfacs.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

hospitalIcon <- makeIcon(
  iconUrl = paste(icon_folder, "hospital-2.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

eslIcon <- makeIcon(
  iconUrl = paste(icon_folder, "esl.png", sep = "/"),
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

schoolIcon <- makeIcon(
  iconUrl = ifelse(
    schools$Grades == "Elementary ", paste(icon_folder, "school-p.png", sep = "/"),
    ifelse(
      schools$Grades == "Middle", paste(icon_folder, "school-m.png", sep = "/"),
      ifelse(
        schools$Grades == "High", paste(icon_folder, "school-h.png", sep = "/"), paste(icon_folder, "school-2.png", sep = "/")
      )
    )
  ),
  iconWidth = 28, iconHeight = 30,
  iconAnchorX = 5, iconAnchorY = 20
)

faithIcons <- icons(
  iconUrl = ifelse(
    Faith$place_type == "church", paste(icon_folder, "cross-2.png", sep = "/"),
    ifelse(
      Faith$place_type == "mosque", paste(icon_folder, "mosque.png", sep = "/"),
      ifelse(
        Faith$place_type == "synagogue", paste(icon_folder, "synagogue-2.png", sep = "/"),
        ifelse(
          Faith$place_type == "hindu_temple", paste(icon_folder, "templehindu.png", sep = "/"),
          paste(icon_folder, "prayer.png", sep = "/")
        )
      )
    )
  ),
  iconWidth = 25, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)