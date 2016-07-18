##### code copyright July 2016
##### written by  Unaiza Ahsan
##### on behalf of Data Science for Social Good - Atlanta
##### for New American Pathways
##### contact: unaiza.ahsan@gmail.com

''' Program usage: Search for Google Places using Google Places API
##### Specify the Google API key. The process of obtaining the key involves the following steps:
      Note: You need to have a Google account!
      1. Click: https://developers.google.com/places/web-service/get-api-key
      2. On the top right corner, click on option "Get a key". Then hit "Continue"
      3. The default option "Create a New Project" is good enough. Click "Continue"
      4. Again, accept the default options and click on "Create". A window will popup with your key.
      5. Paste it in the appropriate line in this code in the variable YOUR_API_KEY

##### Specify the text search query. The following are the text queries we used (you can add/edit to your liking)
      For apartments, TEXT_QUERY = 'apartment complexes'
      For grocery stores, TEXT_QUERY = 'grocery stores'
      For hospitals, TEXT_QUERY = 'primary care locations'
      For SSN offices, TEXT_QUERY = 'SSN offices'
      For faith centers, TEXT_QUERY = 'places of worship'
      For DDS offices, TEXT_QUERY = 'department of driver services'
      For ESL classes, TEXT_QUERY was changed to 'free ESL classes in Atlanta' (without any zipcode) because the search
      results were more relevant.
      For day care centers, TEXT_QUERY = 'day care centers'
      '''

# Import all modules
from googleplaces import GooglePlaces, types, lang
import time
import csv, os, sys
import io, re

YOUR_API_KEY = '----PASTE YOUR GOOGLE PLACES API KEY HERE----'     # Your Google_Places_API key;
TEXT_QUERY = '----PASTE YOUR TEXT QUERY HERE----' # Text query for your places search

if YOUR_API_KEY=='':
    print "Error: API_KEY not given!"
    print "Please add the Google Place API Key in the code: API_KEY=''!"
    exit()

# Point to the directory where all data files are
data_path = os.path.join(sys.path[0], "data")

# We have pulled in zipcodes for fulton and dekalb counties, but if you need zipcodes for other counties, you will have to pull them yourself
# and place in appropriate text files
file_zip_fulton = open(data_path + 'zipcodes_fulton.txt', 'r')
file_zip_dekalb = open(data_path + 'zipcodes_dekalb.txt', 'r')

zipcodes_fulton = file_zip_fulton.readlines()
zipcodes_dekalb = file_zip_dekalb.readlines()
zipcodes = zipcodes_fulton + zipcodes_deklab

op_filename = "_".join( TEXT_QUERY.split() )

# Specifying the output file based on the text query
op_file = open(data_path + 'results_' + op_filename + '.csv', 'a') # this is the output file
csv_writer =  csv.writer(op_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, lineterminator='\n')


fieldnames = ['place_id', 'zipcode', 'place_type', 'place_name', 'latitude', 'longitude', 'website_url', \
              'property_address', 'map_url', 'phone', 'opening_hours']

api_location = 'Georgia, United States'
api_radius = 4000   # kept the radius 4000 metres by trial and error

for i in range(0, len(zipcodes)):
    zipcode = zipcodes[i].strip()
    #print(i)
    api_query = TEXT_QUERY + ' in ' + zipcode

    # Call the API
    try:
        query_result = google_places.text_search(query=api_query, location=api_location, radius=api_radius)
        j = 1
        # Results
        for place in query_result.places:
            # Returned places from a query are place summaries.
            place_name = place.name
            if type(place_name) == unicode:
                place_name = re.sub(r'[^\x00-\x7f]',r'', place_name)

                geo_info_dict = place.geo_location
                latitude = str(geo_info_dict['lat'])
                longitude = str(geo_info_dict['lng'])
                place_id = place.place_id
                place.get_details()

                # Referencing any of the attributes below, prior to making a call to
                # get_details() will raise a googleplaces.GooglePlacesAttributeError.
                dict1 = place.details # A dict matching the JSON response from Google.
                Check if the place is permanently closed (as Google returns those places too)
                if 'permanently_closed' in dict1:
                    break

                    if 'formatted_phone_number' in dict1:
                        phone = dict1['formatted_phone_number']
                    else:
                        phone = ''
                    website_url = place.website
                    map_url = dict1['url']
                    property_address = (dict1['formatted_address'])

                    if type(property_address ) == unicode:
                        property_address = re.sub(r'[^\x00-\x7f]',r'', property_address)
                    place_type = str(dict1['types'][0])
                    try:
                        opening_hours = ', '.join(dict1['opening_hours']['weekday_text'])
                        opening_hours = re.sub(r'[^\x00-\x7f]',r'', opening_hours)
                    except:
                        opening_hours = ''

                        # Writing the field names in output file only in first iteration
                        if i == 0 and j == 1:
                            csv_writer.writerow(fieldnames)

                        # Write all to csv file
                        row = [place_id, zipcode, place_type, place_name, latitude, longitude, website_url, property_address, map_url, phone, opening_hours]
                        csv_writer.writerow(row)
                        time.sleep(2)

                    j = j + 1
    except:
        print "The API rate limit has exceeded. Please re-run the script after 24 hours from %d\'th iteration." %i

op_file.flush()
op_file.close()
print "Thank you. Your output files have been updated for text query: %s" %TEXT_QUERY
