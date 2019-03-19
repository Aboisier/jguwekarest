
usage="Sends certain number of requests with a certain delay between the requests and a certain dataset.

Usage: $(basename "$0") <number_of_requests> <delay_between_requests> <path_to_dataset> <0 or 1 to disable or enable krazy mode> (means the script won't wait for the server response before sleeping and doing the next request)

Alternatively, you can execute a preset:

Small: 2 requests, 1s delay, krazy mode disabled, soybean.arff
$(basename "$0") -s

Small: 5 requests, 1s delay, krazy mode disabled, soybean.arff
$(basename "$0") -m

Small: 2 requests, 0.5s delay, krazy mode disabled, soybean.arff
$(basename "$0") -l

Small: 2 requests, 0 delay, krazy mode enabled, soybean.arff
$(basename "$0") -xl"

number_of_requests=$(($1-1))
interval=$2
file=$3
krazy=$4

while getopts ':hsmlxe:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    s) echo "Executing small load test"
       ./$0 2 2 ./datasets/soybean.arff 0
       exit
       ;;
    m) echo "Executing medium load test"
       ./$0 5 1 ./datasets/soybean.arff 0
       exit
       ;;
    l) echo "Executing large load test"
       ./$0 10 0.5 ./datasets/soybean.arff 0
       exit
       ;;
    x) echo "Executing extra large load test"
       ./$0 10 0.5 ./datasets/soybean.arff 1
       exit
       ;;
    e) exit
       ;;
  esac
done
shift $((OPTIND - 1))

for run in $(eval echo {0..$number_of_requests});
do
    printf "Waiting $interval seconds\n"
    sleep $interval
    if (($krazy == 0))
    then
        echo 'Executing a request...'
        curl -X POST "http://localhost:8080/algorithm/BayesNet" -H "accept: text/uri-list" -H "Content-Type: multipart/form-data" -F "estimator=SimpleEstimator" -F "estimatorParams=0.5" -F "searchAlgorithm=local.K2" -F "useADTree=" -F "validationNum=10" -F "searchParams=-P 1 -S BAYES" -F "datasetUri=" -F "validation=CrossValidation" -F "file=@$file;type=text/plain"
    fi

    if (($krazy == 1))
    then
        echo "Executing a krazy request..."
        curl -X POST "http://localhost:8080/algorithm/BayesNet" -H "accept: text/uri-list" -H "Content-Type: multipart/form-data" -F "estimator=SimpleEstimator" -F "estimatorParams=0.5" -F "searchAlgorithm=local.K2" -F "useADTree=" -F "validationNum=10" -F "searchParams=-P 1 -S BAYES" -F "datasetUri=" -F "validation=CrossValidation" -F "file=@$file;type=text/plain" > &
    fi

    printf '\n\n'
done