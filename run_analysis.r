setwd("E:/Coursera/Get and Clean Data/courseProject/UCI HAR Dataset")
#Read in training and testing data  
y_train=read.table("./train/y_train.txt")
x_train=read.table("./train/x_train.txt")
subject_train=read.table("./train/subject_train.txt")
y_test=read.table("./test/y_test.txt")
x_test=read.table("./test/x_test.txt")
subject_test=read.table("./test/subject_test.txt")

#Merge trainning and testing data set, and save them (Step 1)
dat_x=rbind(x_train,x_test)
dat_y=rbind(y_train,y_test)
dat_subject=rbind(subject_train,subject_test)
save(dat_x,"./dat_x.RData")
save(dat_y,"./dat_y.RData")
save(dat_subject,"./dat_subject.RData")

#Change names of variables, e.g. from "V1" to "tBoday..." (Step 4)
var_names=read.table("./features.txt")
names(dat_x)=var_names[,2]
names(dat_subject)="Subject"
names(dat_y)="Activity"

#Replace number in activity data set with descriptive names (Step 3)
activity_names=read.table("./activity_labels.txt")
activity_names[,2]=as.character(activity_names[,2])
for (i in 1:6){
  dat_y[dat_y==i]=activity_names[i,2]
}


#Extract all measurements on the mean and standard deviation (Step 2)
msr_mean=dat_x[,grep("mean()",names(dat_x),fixed=T)]  #measurements on the mean
msr_std=dat_x[,grep("std()",names(dat_x),fixed=T)]  #measurements on the standard deviation

#Merge all tables we have now 
dat=cbind(dat_subject,dat_y,msr_mean,msr_std)

#Take average of each variable for each activity and each data set (Step 5)
library(reshape2)
dat_melt=melt(dat,id=c("Subject","Activity"),measure.vars=c(names(msr_mean),
                names(msr_std)))
tidy_data=dcast(dat_melt,Subject+Activity ~ variable,mean)

#Export tidy data
write.table(tidy_data,file="tidy_data.txt",sep="\t")



