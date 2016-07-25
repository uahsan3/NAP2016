# Updating Apartments

This is a short guide to add apartments and get them to show on the interactive map. On the landing page, you can see the main map and a tabset on its right titled **"Update Apartments"**. If you click on that, a new tab is displayed and there is a form which you can fill out with details of the apartment complex you want to add. Here is a screenshot to make things clearer. 

![alt text][screenshot1]

[screenshot1]: https://raw.githubusercontent.com/uahsan3/NAP2016/master/screenshots/update_apt.png "Update Apartments"

In this form, there are two mandatory fields:
  - Apartment Name
  - Apartment Address

The rest of the fields are optional. The address is especially important because it will be used later on to extract latitude, longitude information for displaying on the map. 

## After Filling Out Form
Once you press the "Submit" button, you have the option of entering more apartments by clicking on "Submit another response". You can add any number of apartments. Your entries get recorded in a Google spreadsheet. 

![alt text][screenshot2]

[screenshot2]: https://raw.githubusercontent.com/uahsan3/NAP2016/master/screenshots/update_another.png "Update Apartments"

# How to Get Updated Apartment in Interactive Tool
For that, there is a list of steps you need to follow:
1. Download R Studio [Click here to Download for your platform](https://www.rstudio.com/products/rstudio/download/)
2. Navigate to the folder we have shared with you called "NAP2016"
3. Double click on the file "app.R"
4. Type ```rsconnect::deployApp()``` in the R Console
5. Viola! Once the app is deployed, it will reflect the new changes made (added apartments). 