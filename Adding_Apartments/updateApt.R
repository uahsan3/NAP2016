# This script reads the google sheet and extracts lat longs. Then it saves unique rows to 
# the Apartments.csv file

#DISCARDED


# Now figure out if multiple apartments have been added by checking the length of sheet_data
num_apt = dim(sheet_data)[1] # this is the number of entries per column
#num_col = dim(sheet_data)[2] # this is the number of columns [they remain constant]

# Declare empty data frame
df = data.frame(matrix(vector(), 0, 9,
                       dimnames=list(c(), c("apartment_name","latitude","longitude",
                                            "place_id",	"zipcode", "website",	"property_address",	"map_url",	"phone"))),
                stringsAsFactors=F)

if (num_apt > 1) {
  for (i in 2:num_apt){
    
    # Access the address - it is guaranteed to be there as it was mandatory field
    apt_address <- sheet_data$address[i]
    
    # Geocode address -
    lat_long <- geocode(apt_address)
    lat <- lat_long$lat
    lon <- lat_long$lon
    
    # Append the whole line to the Apartments csv file
    # These are the fields in the CSV: apartment_name,latitude,longitude
    # place_id,	zipcode, website,	property_address,	map_url,	phone
    row_to_write <- c(sheet_data$name[i], lat, lon, "", "",
                      sheet_data$website[i], sheet_data$address[i], "", sheet_data$phone[i])
    
    df <- rbind(df, row_to_write)
    # write.table(t(row_to_write), file = "apartments_added.csv", append = TRUE, quote = FALSE, sep = ",",
    #             eol = "\n", na = "", dec = ".", row.names = FALSE, col.names = FALSE,
    #             qmethod = c("double"), fileEncoding = "")
    
    
  }
  
  # Update the Apartments.csv file
  apartments <- read.csv("apartments_added.csv")
  # write to the main file (apartments backup for now)
  to_write <- unique(apartments)
  Apartments_initial <- read.csv(paste('data', 'Apartments.csv', sep='/'), header = TRUE, sep = "," )
  # Concatenate the new additions and existing apartments - and extract unique rows from there
  Apartments_tmp <- rbind(Apartments_initial,to_write)
  Apartments <- unique(Apartments_tmp)
}

