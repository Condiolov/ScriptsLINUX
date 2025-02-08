#!/bin/bash

# Expressão recebida como argumento
expressao="$1"

# Calcula o resultado usando bc
resultado=$(echo "scale=10; $expressao" | bc -l)

# Exibe o resultado
echo "Resultado: $resultado"