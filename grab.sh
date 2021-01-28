#!/bin/bash

for file in $HOME/Desktop/*kisekae*.png ; do
    echo $(basename $file)
    mv $file .
done
