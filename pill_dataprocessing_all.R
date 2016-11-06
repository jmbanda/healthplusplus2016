## Deep Pill Finder v0.01
#
# ██████╗ ███████╗███████╗██████╗     ██████╗ ██╗██╗     ██╗         ███████╗██╗███╗   ██╗██████╗ ███████╗██████╗ 
# ██╔══██╗██╔════╝██╔════╝██╔══██╗    ██╔══██╗██║██║     ██║         ██╔════╝██║████╗  ██║██╔══██╗██╔════╝██╔══██╗
# ██║  ██║█████╗  █████╗  ██████╔╝    ██████╔╝██║██║     ██║         █████╗  ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝
# ██║  ██║██╔══╝  ██╔══╝  ██╔═══╝     ██╔═══╝ ██║██║     ██║         ██╔══╝  ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗
# ██████╔╝███████╗███████╗██║         ██║     ██║███████╗███████╗    ██║     ██║██║ ╚████║██████╔╝███████╗██║  ██║
# ╚═════╝ ╚══════╝╚══════╝╚═╝         ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝
#
# This file: Orginal Code: Juan M. Banda
# dependencies: imager
#
# This file loads images and prepares them for use with mxnet models, building a testing and training set
# for ALL images in dataset

library(imager)
target_size<-32
files_folder <- "/scratch/users/jmbanda/pill/"

##Read Dataset
dataset <- read.csv(paste(files_folder, "gtLabels.csv",sep=""), header = TRUE, sep = ",", as.is = TRUE)

# Dataframe of resized images
rs_df <- data.frame()
rs_labels <-data.frame()
### Min Max Normalization
normalize_function <- function(x){(x-min(x))/(max(x)-min(x))}
r_image=1 #One reference image for every 5 rows
label_number=1
for (i in 1:dim(dataset)[1]) {
    if (r_image==1) { ### We have a reference image
      im <- load.image(paste(files_folder,"dr/",dataset$ReferenceIMAGE[i], sep=''))
      ### Graysclae it
      im <- grayscale(im)
      ### Resize image 28x28 pixels for test
      im <- resize(im,target_size,target_size)
      im_small <- c(as.vector(normalize_function(as.matrix(im))))
      #im_small <-normalize_function(im_small)
      ### add label
      label <- c(label_number)
      vec <- c(label, im_small)
      # Stack in rs_df using rbind
      rs_df <- rbind(rs_df, vec, stringsAsFactors = FALSE)      
    } 
    im <- load.image(paste(files_folder,"dc/",dataset$ConsumerImage[i], sep=''))
    ### Graysclae it
    im <- grayscale(im)
    ### Resize image 28x28 pixels for test
    im <- resize(im,target_size,target_size)
    im_small <- c(as.vector(normalize_function(as.matrix(im))))
    ### add label
    label <- c(label_number)
    vec <- c(label, im_small)
    # Stack in rs_df using rbind
    rs_df <- rbind(rs_df, vec, stringsAsFactors = FALSE)
    r_image=r_image+1
    if (r_image==6) {
      r_image=1
      vecLabels <- c(dataset$LabelNDC[i],label)
      rs_labels <- rbind(rs_labels, vecLabels, stringsAsFactors=FALSE)
      label_number=label_number+1
    }
    cat(paste(label_number,"\n",sep=""))
}
names(rs_labels) <- c("NDC Code", "Numerical Label")
write.csv(rs_labels, paste(files_folder,"labels_master_",target_size,".csv",sep=''), row.names = FALSE)

# Set names. The first columns are the labels, the other columns are the pixels.
names(rs_df) <- c("label", paste("pixel", c(1:(target_size*target_size))))

# Train-test split
#-------------------------------------------------------------------------------
# Simple train-test split. No crossvalidation is done in this tutorial.

# Set seed for reproducibility purposes
set.seed(100)

# Shuffled df
shuffled <- rs_df[sample(1:12000),]

# Train-test split
train <- shuffled[1:11000, ]
test <- shuffled[11001:12000, ]

# Save train-test datasets
write.csv(train, paste(files_folder,"train_pill_all_par_size",target_size,".csv",sep=''), row.names = FALSE)
write.csv(test, paste(files_folder,"test_pill_all_par_size",target_size,".csv",sep=''), row.names = FALSE)
