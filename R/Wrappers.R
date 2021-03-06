Classify <- function(X, Data, Cat, Sigma = NULL, Gamma = NULL , Lambda = NULL){
  if(ncol(X) != ncol(Data)) stop("Number of features in X and TrainData are different.")
  if( is.null(Sigma) || is.null(Gamma) || is.null(Lambda)){
    output <- SelectParams(Data, Cat)
    Sigma <- output$Sigma
    Gamma <- output$Gamma
    Lambda <- output$Lambda
  }
  
  Y <- IndicatMat(Cat)$Categorical
  Theta <- OptScores(Cat)
  YTheta <- Y %*% Theta
  
  output <- SparseKernOptScore(Data, Cat, w0 = rep(1, ncol(Data)), Lambda = Lambda,
                               Gamma = Gamma, Sigma = Sigma, Maxniter = 100,
                               Epsilon = 1e-05, Error = 1e-05)
  
  w <- output$Weights
  Dvec <- output$Dvec
  
  Kw <- KwMat( Data , w, Sigma)
  
  # Create projection Values
  TrainProjections <- GetProjection(X = Data, Data = Data, Cat = Cat, Dvec=Dvec, w = w, Kw = Kw, Sigma = Sigma, Gamma = Gamma )
  
  ### Need test projection values for LDA
  NewProjections <- GetProjection(X = X, Data = Data, Cat = Cat, Dvec=Dvec,  w = w, Kw = Kw, Sigma = Sigma , Gamma = Gamma )
  NewProjections <- as.data.frame(NewProjections)
  colnames(NewProjections) <- c("Projections")
  
  ### All of this is used to create discirminant line
  Training <- data.frame(Cat, TrainProjections)
  colnames(Training) <- c("Category", "Projections")
  
  ## fit LDA on training projections
  LDAfit <- MASS::lda(Category ~ Projections, data = Training)
  
  # Predict class membership using LDA
  Predictions <- stats::predict(object = LDAfit, newdata = NewProjections)$class
  
  return(list(Predictions = Predictions, Weight = w, Dvec = Dvec))
}

is.not.null <- function(x) !is.null(x)


#' @title Function which generates feature weights, discriminant vector, and class predictions.
#' @param X (m x p) Matrix of unlabelled data with numeric features to be classified. Cannot have missing values.
#' @param Data (n x p) Matrix of training data with numeric features. Cannot have missing values.
#' @param Cat (n x 1) Vector of class membership corresponding to Data. Values must be either 1 or 2.
#' @param Sigma Scalar Gaussian kernel parameter. Default set to NULL and is automatically generated if user-specified value not provided. Must be > 0. User-specified parameters must satisfy hierarchical ordering.
#' @param Gamma Scalar ridge parameter used in kernel optimal scoring. Default set to NULL and is automatically generated if user-specified value not provided. Must be > 0. User-specified parameters must satisfy hierarchical ordering.
#' @param Lambda Scalar sparsity parameter on weight vector. Default set to NULL and is automatically generated by the function if user-specified value not provided. Must be >= 0. When Lambda = 0, SparseKOS defaults to kernel optimal scoring of [Lapanowski and Gaynanova, preprint] without sparse feature selection. User-specified parameters must satisfy hierarchical ordering.
#' @param Epsilon Numerical stability constant with default value 1e-05. Must be > 0 and is typically chosen to be small.
#' @references Lapanowski, Alexander F., and Gaynanova, Irina. ``Sparse feature selection in kernel discriminant analysis via optimal scoring'', preprint.
#' @description Returns a (m x 1) vector of predicted group membership (either 1 or 2) for each data point in X. Uses Data and Cat to train the classifier.
#' @details Function which handles classification. Generates feature weight vector and discriminant coefficients vector in sparse kernel optimal scoring. If a matrix X is provided, the function classifies each data point using the generated feature weight vector and discriminant vector. Will use user-supplied parameters Sigma, Gamma, and Lambda if any are given. If any are missing, the function will run SelectParams to generate the other parameters. User-specified values must satisfy hierarchical ordering.
#' @examples 
#' Sigma <- 1.325386  #Set parameter values equal to result of SelectParam.
#' Gamma <- 0.07531579 #Speeds up example.
#' Lambda <- 0.002855275
#' Predict(X = Data$TestData , 
#'          Data = Data$TrainData , 
#'          Cat = Data$CatTrain , 
#'          Sigma = Sigma , 
#'          Gamma = Gamma , 
#'          Lambda = Lambda)
#' @return  A list of
#' \item{Predictions}{ (m x 1) Vector of predicted class labels for the data points in Data. Only included in non-null value of X is provided.} 
#' \item{Weights}{ (p x 1) Vector of feature weights.} 
#' \item{Dvec}{(n x 1) Discrimiant coefficients vector.}
#' @export
Predict <- function(X = NULL, Data, Cat, Sigma = NULL, Gamma = NULL, Lambda = NULL, Epsilon = 1e-05){
  ## Check for Violatin of Hierarchical Ordering
  if(is.not.null(Lambda) & (is.null(Sigma) || is.null(Gamma))){
    stop("Hierarchical definining of parameters violated.")
  }
  if(is.not.null(Gamma) & is.null(Sigma)){
    stop("Hierarchical definining of parameters violated.")
  }
  if(is.null(Lambda)){
    output <- SelectParams(Data = Data, Cat = Cat , Sigma = Sigma, Gamma = Gamma, Epsilon = Epsilon)
    Sigma <- output$Sigma
    Gamma <- output$Gamma
    Lambda <- output$Lambda
  }
  
  output <- SparseKernOptScore(Data, Cat, rep(1, ncol(Data)), Lambda, Gamma, Sigma)
  w <- output$Weights
  Dvec <- output$Dvec
  
  if(is.null(X)){
    return(list(Weights = w, Dvec = Dvec))
  }
  else{
    Predict <- Classify(X, Data, Cat, Sigma, Gamma, Lambda)
    return(Predict)
  }
}