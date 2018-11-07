# sparseKOS
This is a Git repository for sparse kernel optimal scoring. The R package `sparseKOS` is used for non-linear binary classification with simulataneous sparse feature selection. The corresponding reference is Lapanowski, Alexander F., and Gaynanova, Irina ''Sparse feature selection in kernel discriminant analysis via optimal scoring'', preprint.

# Installation 
```
devtools::install_github("aflapan/sparseKOS")
```
# Functions

There are three functions in `sparseKOS`. 

The first is `SelectParams`, which implements the automatic variable select methods used in sparse kernel optimal scoring. The user is allowed to specify the values of either `Sigma` or both `Sigma, Gamma`. 

 It has implementation
```
SelectParams( Data, Cat, Sigma = NULL, Gamma = NULL, Epsilon = 1e-05)
```

The second function is `Predict`. It has implementation 
```
Predict( X = NULL , Data, Cat, Sigma = NULL, Gamma = NULL, Lambda = NULL)
```

The third function is ``GetProjection``. It has the implementation
```
GetProjection( Data, Cat, Sigma = NULL, Gamma = NULL, Lambda = NULL)
```

# Hierarchical Parameters
Sparse kernel optimal scoring has three parameters: a Gaussian kernel parameter `Sigma`, a ridge parameter `Gamma`, and a sparaity parameter `Lambda`. They have a hierarchical dependency, in that `Sigma` influences `Gamma`, and both influence `Lambda`. Thus, when using the package `sparseKOS`, the user will be allowed to specify certain combinations of parameters and not be allowed to specify other combinations. The user will not be allowed to specify any combinations which violate the hierarchical ordering of the parameters. Thus, they will be allowed to specify a value for `Sigma` but not for either `Gamma` or `Lambda`. Likewise, they are allowed to specify values for both `Sigma` and `Gamma` but not for `Lambda`. The user will NOT be allowed to specify a value for `Lambda` while leaving either `Sigma` or `Gamma` undefined. 


# Examples

```
library(sparseKOS)

SelectParams(Data = Data$TrainData,
             Cat = Data$CatTrain)
```
For an example with pre-specified parmeter values:
```
Sigma <- 1.325386
Gamma <- 0.07531579
Lambda <- 0.002855275

Predict( X = Data$TestData,
         Data = Data$TrainData,
         Cat = Data$CatTrain, 
         Sigma = Sigma,
         Gamma = Gamma, 
         Lambda = Lambda)
         
Predict( Data = Data$TrainData,
         Cat = Data$CatTrain, 
         Sigma = Sigma,
         Gamma = Gamma, 
         Lambda = Lambda)
```
Note that two different lists are returned in the above examples. The first example returns a list which includes the predicted class memberships for the unlabelled data in `X = Data$TestData` along with the final weights `Weights` and discriminant vector `Dvec`. The second example does not supply a value for the `X` variable and thus does not return predicted class memberships. 
