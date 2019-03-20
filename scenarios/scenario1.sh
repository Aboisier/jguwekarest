for i in {0..5}
    do
        curl -X POST "http://localhost:8080/algorithm/BayesNet" -H "accept: text/uri-list" -H "Content-Type: multipart/form-data" -F "estimator=SimpleEstimator" -F "estimatorParams=0.5" -F "searchAlgorithm=local.K2" -F "useADTree=0" -F "validationNum=10" -F "searchParams=-P 1 -S BAYES" -F "datasetUri=" -F "validation=CrossValidation" -F "file=@contact-lenses.arff"
        sleep 1
    done