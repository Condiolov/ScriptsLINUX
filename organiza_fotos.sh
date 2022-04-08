#!/usr/bin/env bash
###################################################################################
# Script : organiza_file.sh
# Versão : 1.0 (/home/thiago/Documentos/_imp/_scripts/organiza_file.sh)
# Autor  : Thiago Condé
# Data   : 2022-04-06 21:38:59
# Info   : Organiza fotos (Arquivos) por data copaindo preservando detalhes de cada arquivo, em pasta de ano e mês, não repete foto, caso tenha mesmo nome, fotos de mesmo nome mas de hash diferente ou seja fotos tiradas no mesmo dia com o mesmo equipamento são preservadas, copiar literalemente tudo.
# Requis.: organiza_file "pasta_origem" "pasta_destino"
###################################################################################
pasta_origem=$1
pasta_destino=$2
mes_por_escrito=(zero janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro)

clear
OIFS="$IFS"
IFS=$'\n'
contador=0
# Função recursiva para garantir que mais arquivos de nome iguais e hash diferentes sejam salvos. Arquivos de nome iguais e hash igual não sao copiados.
renomear_arquivos_duplicado() {
	pasta="$1"
	arquivo_nome="$2"
	arquivo="$3"
	contador="$4"

	if (($contador >= 1)); then              #caso tenha arquivo de mesmo nome
		pesquisar_por="$arquivo_nome $contador" #responsavel por renomear arquivo file 1.jpg file 2.jpg etc..
	else
		pesquisar_por=$arquivo_nome #caso o contador seja 0 nome normal
	fi

	if [ -f "$pasta/$pesquisar_por" ]; then # Se nao existe o arquivo copio normalmente SE O ARQUIVO EXITE comparo o hash

		# sugestão do @garga cmp -s compara arquivos byte a byte
		# 		if [ "$(md5sum <"$pasta/$pesquisar_por")" = "$(md5sum <"$arquivo")" ]; then
		if cmp -s "$pasta/$pesquisar_por" "$arquivo"; then # comparo arquivo se sao iguai
			echo -n '='                                       # se for igual printo = na tela

		else
			((contador++))
			echo -n "|" #nomes iguais hash diferentes..
			# Chamo a função nomavemente incrementando o contador e verificando nomes iguais
			renomear_arquivos_duplicado "$pasta" "$arquivo_nome" "$arquivo" "$contador"
		fi
	else # caso o arquivo nao exista copio normalmente
		contador=0
		echo -n "+"
		cp -p "$arquivo" "$pasta/$pesquisar_por" #-p preservo os detalhes do arquivo como data de modificação
	fi
}

# Pe
for arquivo in $( #varro todos os arquivos dentro de pasta e subpasta
	find "$pasta_origem"
); do

	data_modificacao=$(stat "$arquivo" -c '%y') #PEGO A DATA DE MODIFICAÇÂO
	ano=$(echo $data_modificacao | cut -f1 -d-) #PEGO O ANO
	mes=$(echo $data_modificacao | cut -f2 -d-) #PEGO O MES
	mes=${mes##0} # ou mes=$((10#$mes)) #removo 0 dos meses
	dia=$(echo $data_modificacao | cut -f3 -d-)
	dia=$(echo $dia | cut -f1 -d\ )				#PEGO O DIA
	arquivo_nome=$(basename "$arquivo") #nome do arquivo com extensão

	if [ -f "$arquivo" ]; then #VEJO SE é um arquivo e não uma pasta
		#echo "Nome:$arquivo_nome Ano:$ano  Mes:$mes Dia:$dia"; exit
		mkdir -p "$pasta_destino/$ano/${mes_por_escrito[$mes]}" # crio a pasta de acordo com cada arquivo
		renomear_arquivos_duplicado "$pasta_destino/$ano/${mes_por_escrito[$mes]}" "$arquivo_nome" "$arquivo" $contador
	fi

done
exit
