#!/bin/bash
###################################################################################
# Script : cameras.sh
# Versão : 1.0 (/home/thiago/Documentos/_imp/_scripts/novos/cameras.sh)
# Autor  : Thiago Condé
# Data   : 2022-03-31 08:36:43
# Info   : Fazer o monitoramento das cameras motorola pelo linux, sucesso!!
# Requis.: VLC instalado. Config: Preferencias / Interface / Marque instancia unica!!
# Agrad. : Grupo telegram shellbr (@rbgarga)
###################################################################################
source /home/thiago/Documentos/_imp/_scripts/senha_dvr
# login="seu_login_DVR"
# senha="sua_senha_DVR"
ip="10.0.0.143"
porta="554"


pai="$(pgrep cameras.sh)"
vlc=$(pgrep vlc)

if [ ${#vlc} -gt 4 ]; then # fecho o vlc se estiver aberto
	pkill -9 -e -f vlc
fi

if [ ${#pai} -gt 6 ]; then # fecho o script se estiver aberto e paro o script
	pkill -9 -e -f cameras.sh
	exit 0
fi

while true; do
	#   cvlc  -v -R rtsp://$login:$senha@$ip:$porta/h264?ch=1 & sleep 10
	vlc v4l2 rtsp://$login:$senha@$ip:$porta/h264?ch=1 &>/dev/null &
	sleep 10
	#     vlc v4l2   rtsp://$login:$senha@$ip:$porta/h264?ch=4  &> /dev/null & sleep 10
done
exit
