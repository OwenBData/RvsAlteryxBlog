##Dataset
Austria <- read.csv('Austria.csv')

#Packages
#install.packages('zoo')
library('zoo')

#Step 1: Alter data structures & rename columns
#CUSTNAME -> 'CustomerName'
colnames(Austria)[14] <- 'CustomerName'

#Check Data Types
str(Austria)
#Check Quantity, UnitCost, Sales are in Numeric forms

#Step 2: Create Total Costs Column - Quantity * UnitCost
Austria$TotalCosts <- Austria$Quantity * Austria$UnitCost
#Create Profit: Sales - Total Costs
Austria$Profit <- Austria$Sales - Austria$TotalCosts

#Step 3: Split OrderID Column Into 3

#Extract OrderID column into a dataframe
OrderID <- data.frame(Austria$Order.ID)

#Construct a new dataframe, splitting OrderID into 3 columns based off the delimiter '-'. 
OrderID_Impute <- data.frame(do.call('rbind', strsplit(as.character(OrderID$Austria.Order.ID),'-',fixed=TRUE)))

#Add OrderID_Impute Column back to Original Dataframe (choosing the 3rd column of OrderID_Impute)
Austria$Order.ID <- OrderID_Impute[3]
#ERROR: WE MUST IMPUTE FIRST USING THIS METHOD.

#Step 3 (Amended): Fill NAs, taking the top value to impute for lower values 
#Set blank fields within Order.ID to NA.
Austria$Order.ID[Austria$Order.ID==''] <- NA

#Use 'Zoo' package with Unlist & Lapply to fill in missing NAs.(na.locf carries last obvservation forward)
OrderID_Imputed <-  as.data.frame(na.locf(Austria$Order.ID))
colnames(OrderID_Imputed)[1] <- 'OrderID_Filled'


#Step 4: Split OrderID into 3 columns
OrderID_Impute_Split <- data.frame(do.call('rbind', strsplit(as.character(OrderID_Imputed$OrderID_Filled),'-',fixed=TRUE)))

#Add Desired Column (OrderID_Impute_Split$X3 back into the dataframe. )
Austria$Order.ID <- OrderID_Impute_Split$X3

