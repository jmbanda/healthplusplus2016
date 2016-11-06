## Deep Pill Finder v0.01
#
# ██████╗ ███████╗███████╗██████╗     ██████╗ ██╗██╗     ██╗         ███████╗██╗███╗   ██╗██████╗ ███████╗██████╗ 
# ██╔══██╗██╔════╝██╔════╝██╔══██╗    ██╔══██╗██║██║     ██║         ██╔════╝██║████╗  ██║██╔══██╗██╔════╝██╔══██╗
# ██║  ██║█████╗  █████╗  ██████╔╝    ██████╔╝██║██║     ██║         █████╗  ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝
# ██║  ██║██╔══╝  ██╔══╝  ██╔═══╝     ██╔═══╝ ██║██║     ██║         ██╔══╝  ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗
# ██████╔╝███████╗███████╗██║         ██║     ██║███████╗███████╗    ██║     ██║██║ ╚████║██████╔╝███████╗██║  ██║
# ╚═════╝ ╚══════╝╚══════╝╚═╝         ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝
#
# This file: Orginal Code: Rohit Vashisht, modified by: Juan M. Banda
# dependencies: mxnet
#
# This file builds the model and provides evaluations

buildPillModel <- function(dimOne,dimTwo,trainFile,intEpochs, strActF, nClass){
  train <- read.csv(trainFile, stringsAsFactors = FALSE)

  train <- data.matrix(train)
  lastCol=dimOne*dimTwo +1 
  train_x <- t(train[, -lastCol])
  train_y <- train[, lastCol]
  
  train_array <-train_x
  
  dim(train_array) <- c(dimOne,dimTwo, 1, ncol(train_x))

  data <- mx.symbol.Variable('data')
  
  conv_1 <- mx.symbol.Convolution(data = data, kernel = c(5, 5), num_filter = 20)
  tanh_1 <- mx.symbol.Activation(data = conv_1, act_type = c(strActF))
  pool_1 <- mx.symbol.Pooling(data = tanh_1, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
  # 2nd convolutional layer
  conv_2 <- mx.symbol.Convolution(data = pool_1, kernel = c(5, 5), num_filter = 50)
  tanh_2 <- mx.symbol.Activation(data = conv_2, act_type = c(strActF))
  pool_2 <- mx.symbol.Pooling(data=tanh_2, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
  # 1st fully connected layer
  flatten <- mx.symbol.Flatten(data = pool_2)
  fc_1 <- mx.symbol.FullyConnected(data = flatten, num_hidden = 500)
  tanh_3 <- mx.symbol.Activation(data = fc_1, act_type = c(strActF))
  # 2nd fully connected layer
  fc_2 <- mx.symbol.FullyConnected(data = tanh_3, num_hidden = nClass)
  # Output. Softmax output since we'd like to get some probabilities.
  NN_model <- mx.symbol.SoftmaxOutput(data = fc_2)
  
  mx.set.seed(100)
  devices <- mx.cpu()
  
  model <- mx.model.FeedForward.create(NN_model,
                                       X = train_array,
                                       y = train_y,
                                       ctx = devices,
                                       num.round = intEpochs,
                                       array.batch.size = 40,
                                       learning.rate = 0.01,
                                       momentum = 0.9,
                                       eval.metric = mx.metric.accuracy,
                                       epoch.end.callback = mx.callback.log.train.metric(100))
  return(model)
}

########## Main Code #############
library(mxnet)
##### Small Example - 64x64 images 
resultingModel <- buildPillModel(28,28,'/Users/juanbanda/Documents/CODE/healthplusplus2016/datasets/norm_train_pill_test_par_size28.csv',160,'relu', 40)
### Predict on the test file
test <- read.csv('/Users/juanbanda/Documents/CODE/healthplusplus2016/datasets/norm_test_pill_test_par_size28.csv', stringsAsFactors = FALSE)
test <- data.matrix(test)
lastCol=28*28 +1
test_x <- t(test[, -lastCol])
test_y <- test[, lastCol]
test_array <- test_x
dim(test_array) <- c(28,28, 1, ncol(test_x))
predicted <- predict(resultingModel, test_array)
predicted_labels <- max.col(t(predicted)) - 1
table(test[, lastCol], predicted_labels)
NnAuc <- sum(diag(table(test[, lastCol], predicted_labels)))/20

## Save trained model
mx.model.save(resultingModel, 'mxnet-model',iteration=160)


##### Large Example - Unzip the zipped datasets
#res<- pillMe(32,32,'/Users/juanbanda/Documents/CODE/healthplusplus2016/norm_train_pill_all_par_size32.csv',15,'relu',10000)
#test <- read.csv('/Users/juanbanda/Documents/CODE/healthplusplus2016/norm_test_pill_all_par_size32.csv', stringsAsFactors = FALSE)
#test <- data.matrix(test)
#lastCol=32*32 +1
#test_x <- t(test[, -lastCol])
#test_y <- test[, lastCol]
#test_array <- test_x
#dim(test_array) <- c(32,32, 1, ncol(test_x))
#predicted <- predict(resultingModel, test_array)
#predicted_labels <- max.col(t(predicted) - 1)
#NnAuc <- sum(diag(table(test[, lastCol], predicted_labels)))/2000