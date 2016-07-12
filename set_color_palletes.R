#Set Color Palettes
#pal1 <- colorNumeric( palette = "GnBu", domain = Aff$Rent)
binpal <- colorBin("Blues", Rent$Rent, 6, pretty = TRUE)
pal2 <- colorQuantile(palette = "RdPu", domain = Aff$local_job_)
pal3 <- colorQuantile(palette = "RdPu", domain = Aff$retail_acc)
pal4 <- colorFactor(rainbow(4), schools$Grades)