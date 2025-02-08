#!/bin/bash

# Calcula o resultado usando bc
echo "calculadora"
echo "scale=10; $@" | bc -l
