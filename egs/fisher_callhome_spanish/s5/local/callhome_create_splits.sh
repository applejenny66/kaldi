#!/usr/bin/env bash
# Copyright 2014  Gaurav Kumar.   Apache 2.0

data_dir=data
train_all=data/callhome_train_all

if [ $# -lt 1 ]; then
    echo "Specify the location of the split files"
    exit 1;
fi

splitFile=$1

# Train first
for split in train dev test
do
  dirName=callhome_$split

  cp -r $train_all $data_dir/$dirName

  awk 'BEGIN {FS=" "}; FNR==NR { a[$1]; next } ((substr($2,0,length($2)-2) ".sph") in a)' \
  $splitFile/$split $train_all/segments > $data_dir/$dirName/segments

  n=`awk 'BEGIN {FS = " "}; {print substr($2,0,length($2)-2)}' $data_dir/$dirName/segments | sort | uniq | wc -l`

  echo "$n conversations left in split $dirName"

  utils/fix_data_dir.sh $data_dir/$dirName
  utils/validate_data_dir.sh $data_dir/$dirName
done

