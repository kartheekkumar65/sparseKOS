#' Example Data. 
#'
#'
#'
#' List containing training and test data along with categorical labels for example data.
#' 
#' 
#' @format A list consisting of:
#' \describe{
#'   \item{TrainData}{ (179 x 4) Matrix of training data features. the first two features satisfy sqrt(x_{i1}^2 + x_{i2}^2) > 2/3 if the ith sample is in class 1. 
#' Otherwise, they satisfy sqrt(x_{i1}^2 + x_{i2}^2) < 2/3 - 1/10 if the ith sample is in class 2. 
#' The third and fourth features are generated as independent N(0, 1/2) noise.}
#'   \item{TestData}{ (94 x 4) Matrix of test data features. the first two features satisfy sqrt(x_{i1}^2 + x_{i2}^2) > 2/3 if the ith sample is in class 1. 
#' Otherwise, they satisfy sqrt(x_{i1}^2 + x_{i2}^2) < 2/3 - 1/10 if the ith sample is in class 2. 
#' The third and fourth features are generated as independent N(0, 1/2) noise.}
#'   \item{CatTrain}{ (179 x 1) Vector of class labels for the training data.}
#'   \item{CatTest}{ (94 x 1) Vector of class labels for the test data.}
#'   ...
#' }
#' @source Simulation model 1 from [Lapanowski and Gaynanova, preprint].
#' @references Lapanowski, Alexnader F., and Gaynanova, Irina. ``Sparse Feature Selection in Kernel Discriminant Analysis via Optimal Scoring'', preprint.
"Data"