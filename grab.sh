#!/bin/bash

for file in $HOME/Desktop/*kisekae*.png ; do
    echo $file
    mv $file .
done
