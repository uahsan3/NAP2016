##### code copyright July 2016
##### written by  Unaiza Ahsan
##### on behalf of Data Science for Social Good - Atlanta
##### for New American Pathways
##### contact: unaiza.ahsan@gmail.com

''' Program usage: Search for schools in Dekalb and Fulton counties, GA using Great Schools API
##### Specify the Great Schools API key. The process of obtaining the key involves the following steps:
      1. Click: http://www.greatschools.org/api/registration.page
      2. Fill out the form under the title "Request a key for the GreatSchool API"
      3. After submitting the request form, they usually send you the API key within a day
      4. Paste that key in the appropriate line in this code in the variable YOUR_API_KEY
'''

YOUR_API_KEY = '----PASTE YOUR Great Schools API KEY HERE----'     # Your Great Schools API key

if YOUR_API_KEY=='':
    print "Error: API_KEY not given!"
    print "Please add the Great Schools API Key in the code: YOUR_API_KEY=''!"
    exit()

# Import all modules
import requests
from xml.etree import ElementTree
import os
import time
import re
import csv

# Point to the directory where all data files are
data_path = os.path.join(sys.path[0], "data")

# Input files with cities in Fulton and Dekalb counties
# We collected the cities for fulton and dekalb and put them in respective text files. Please do so for other cities
file_cities_fulton = open(data_path + 'cities_fulton.txt', 'r')
file_cities_dekalb = open(data_path + 'cities_dekalb.txt', 'r')


fieldnames = ['school_id', 'school_name', 'school_type', 'gradeRange', 'city', 'address', \
              'phone', 'fax', 'website', 'latitude', 'longitude', 'overview_url', 'ratings_url', 'reviews_url', 'freeandreducedLunch']

cities_fulton = file_cities_fulton.readlines()
cities_dekalb = file_cities_dekalb.readlines()

cities = cities_fulton + cities_dekalb

op_file = open(data_path + 'Schools.csv', 'a') # this is the output file
csv_writer =  csv.writer(op_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_ALL, lineterminator='\n')

for i in range(0, len(cities)):
    city = cities[i].strip() # if city has spaces, replace that with hyphens. I've done that using text mechanic

    # forming full URL
    url_s1 = 'http://api.greatschools.org/schools/'
    url_s2 = 'GA/' # For Georgia
    url_s4 = '?key='
    api_key = YOUR_API_KEY
    url_s5 = '&limit=-1' # For all results
    final_url = url_s1 + url_s2 + city + url_s4 + api_key + url_s5

    response = requests.get(final_url)

    tree = ElementTree.fromstring(response.content)

    for j in range(0, len(tree)): # Limit is 3000 requests per day so adjust accordingly
        print(i, j)
        school_id = tree[j].find('gsId').text
        school_name = tree[j].find('name').text
        school_type = tree[j].find('type').text
        gradeRange = tree[j].find('gradeRange').text
        #parentRating = tree[j].find('parentRating').text
        #district = tree[j].find('district').text
        address = tree[j].find('address').text
        final_address = address.replace('\n', '')

        phone = tree[j].find('phone').text
        fax = tree[j].find('fax').text
        website = tree[j].find('website').text
        latitude = tree[j].find('lat').text
        longitude = tree[j].find('lon').text
        overview_url = tree[j].find('overviewLink').text
        ratings_url = tree[j].find('ratingsLink').text
        reviews_url = tree[j].find('reviewsLink').text

         # Retrieving GreatSchools Census Data using their API
        url_1 = 'http://api.greatschools.org/school/census/'
        state = 'GA'
        url_2 = '/'
        id_school = school_id
        url_4 = '?key='
        key = YOUR_API_KEY

        final_url_census = url_1 + state + url_2 + id_school + url_4 + key
        response1 = requests.get(final_url_census)
        tree1 = ElementTree.fromstring(response1.content)
        try:
            free_reduced = tree1.find('freeAndReducedPriceLunch').text
        except:
            free_reduced = ''
        # Writing the field names in both files
        # only in first iteration
        if i == 0 and j == 0:
            csv_writer.writerow(fieldnames)

        row = [school_id, school_name, school_type, gradeRange, city, final_address, phone, fax, website, \
               latitude, longitude, overview_url, ratings_url, reviews_url, free_reduced]
        csv_writer.writerow(row)
        #time.sleep(1)
op_file.flush()
