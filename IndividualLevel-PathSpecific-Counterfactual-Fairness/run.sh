#!/usr/bin/env bash
today="$(date '+%y%m%d')"
dirname_out=out-$today
dirname_err=err-$today
if [ ! -e $PWD/log/$dirname_out ] || [ ! -e $PWD/log/$dirname_err ]; then
    mkdir $PWD/log
    mkdir $PWD/log/$dirname_out
    mkdir $PWD/log/$dirname_err
fi
for ((i=0; i<1; i++))
do
filename=${i}_DNNProposed_synth
lambda_fair=$1
if [ -z "$lambda_fair"]
then
    lambda_fair=0.2
fi
nn_type=1
mode=${filename##*_}
synth_num=${filename%%_*}

if [[ $filename =~ Logistic ]] ; then
    nn_type=2
fi

echo "$(date '+%y/%m/%d %H:%M:%S') $filename"
python3 run.py -l $lambda_fair -m $mode -nt $nn_type -sn $synth_num \
    > $PWD/log/$dirname_out/$filename-$synth_num-nn$nn_type.log \
    2> $PWD/log/$dirname_err/$filename-$synth_num-nn$nn_type.log  
done 
