% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/score_expression.R
\name{score_expression}
\alias{score_expression}
\alias{score_expression.bayesglm}
\alias{score_expression.cv.glmnet}
\alias{score_expression.default}
\alias{score_expression.glm}
\alias{score_expression.glmboost}
\alias{score_expression.lm}
\title{Unevaluated prediction expressions for models}
\usage{
score_expression(mod, response = NULL)

\method{score_expression}{default}(mod, response = NULL)

\method{score_expression}{glm}(mod, response = NULL)

\method{score_expression}{lm}(mod, response = NULL)

\method{score_expression}{bayesglm}(mod, response = NULL)

\method{score_expression}{glmboost}(mod, response = NULL)

\method{score_expression}{cv.glmnet}(mod, response = NULL)
}
\arguments{
\item{mod}{A supported model object.}

\item{response}{The name of a custom response function to apply to the linear predictor.}
}
\value{
An unevaluated R call object representing the response function of the linear predictor.

None
}
\description{
Generate an unevaluated call corresponding to the predict step of the passed
model. The call represents the response function of the linear predictor in terms
of elementary functions on the underlying column names, and is suitable for
direct translation into SQL.
}
\section{Warning}{

The Binomial models in glmboost return coefficients which are 1/2 the coefficients
fit by a call to glm(..., family=binomial(...)), because the response variable is
internally recoded to -1 and +1. sqlscore multiplies the returned coefficients by 2
to put them back on the same scale as glm, and adds the glmboost offset to the
intercept before multiplying.
}
\examples{
# A Gaussian GLM including factors
mod <- glm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width + Species,
           data=datasets::iris)
score_expression(mod)

# A binomial GLM - linear predictor is unaffected
mod <- glm(Sepal.Length > 5.0 ~ Sepal.Width + Petal.Length + Petal.Width + Species,
           data=datasets::iris, family=binomial("logit"))
score_expression(mod)

#With a hand-specified response function
score_expression(mod, response="probit")

#With formula operators
x <- matrix(rnorm(100*20),100,20)
colnames(x) <- sapply(1:20, function(x) paste0("X", as.character(x)))
x <- as.data.frame(x)
mod <- glm(X2 ~ X3 + X5 + X15*X8, data=x)
score_expression(mod)

}

