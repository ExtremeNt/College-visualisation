Location<-read.table("LocationPlace.txt")
attach(College)
levels(Private)<-c("Public", "Private")
CollegeSmall<-as.data.frame(cbind(Private,Apps,Accept,Enroll,Expend,
                                  Grad.Rate,Top25perc,Location, row.names(College)))
names(CollegeSmall)[10]<-"Name"
row.names(CollegeSmall)<-row.names(College)
rm(College)
attach(CollegeSmall)

mappop<-rep(0,777)
for (i in 1:777){
  mappop[i]<-paste0("<b>",CollegeSmall$Name[i], "</b><br>",
                    "<b>",CollegeSmall$Private[i], "</b><br>",
                    "<b>", "Applications: ", "</b>" ,CollegeSmall$Apps[i], "<br>",
                    "<b>", "Applicatants accepted: ", "</b>" ,CollegeSmall$Accept[i], "<br>",
                    "<b>", "Enrollments: ", "</b>" ,CollegeSmall$Enroll[i]
  )
}

CollegeSmall<-as.data.frame(cbind(CollegeSmall,mappop))
attach(CollegeSmall)
