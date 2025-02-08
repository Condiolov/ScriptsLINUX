#!/bin/bash

# Calcula o resultado usando bc
echo "scale=10; $@" | bc -l
