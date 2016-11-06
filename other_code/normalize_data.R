pathH <- '/Users/juanbanda/Documents/CODE/healthplusplus2016/'
### Min Max Normalization function
normalize_function <- function(x){(x-min(x))/(max(x)-min(x))}

### Handle train file ###
dataset <- read.csv(paste(pathH,"train_pill_all_size32.csv",sep=""), header = TRUE, sep = ",", as.is = TRUE)
labels_df <- data.frame()
labels_df <- dataset$label
drops <- c("label")
datset <- as.matrix(dataset[ , !(names(dataset) %in% drops)])
dataset <- as.data.frame(normalize_function(datset))
dataset$label <- labels_df
write.csv(dataset, paste(pathH,"norm_train_pill_all_par_size32.csv",sep=''), row.names = FALSE)

### Handle test file ###
dataset <- read.csv(paste(pathH,"test_pill_all_size32.csv",sep=""), header = TRUE, sep = ",", as.is = TRUE)
labels_df <- data.frame()
labels_df <- dataset$label
drops <- c("label")
datset <- as.matrix(dataset[ , !(names(dataset) %in% drops)])
dataset <- as.data.frame(normalize_function(datset))
dataset$label <- labels_df
write.csv(dataset, paste(pathH,"norm_test_pill_all_par_size32.csv",sep=''), row.names = FALSE)
