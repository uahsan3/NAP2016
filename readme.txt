1) The Search functionality in R needs the latest build of leaflet (not the standard one we have been using). Hence we need to install devtools first using this command:
install.packages(c('devtools','curl'))

2) Then we need to install the github repo with the latest leaflet package using this command:
devtools::install_github('byzheng/leaflet')
