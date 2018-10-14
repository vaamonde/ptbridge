#!/bin/bash
# Autor: Robson Vaamonde
# Site: www.procedimentosemti.com.br
# Facebook: facebook.com/ProcedimentosEmTI
# Facebook: facebook.com/BoraParaPratica
# YouTube: youtube.com/BoraParaPratica
# Data de criação: 13/10/2018
# Data de atualização: 13/10/2018
# Versão: 0.1
# Testado e homologado para a versão do Ubuntu Desktop 16.04 e 18.04 LTS x64
# Testado e homologado para a versão do Linux Mint 18 e 19 LTS x64
# Placa de Rede TUN/TAP: https://en.wikipedia.org/wiki/TUN/TAP
# Placa de Rede Bridge: https://en.wikipedia.org/wiki/Bridging_(networking)
# Placa de Rede Promíscua: https://en.wikipedia.org/wiki/Promiscuous_mode

#Declarando as variáveis de ambiente para a Placa de Rede Tun/Tap e Bridge
INTERFACE_LAN="enp6s0"
INTERFACE_TUNTAP="tap0"
INTERFACE_BRIDGE="br0"
IP_PACKETTRACER="192.168.0.103"
PORT_PACKETTRACER="3800"
PASSWORD_PACETTRACER="123456"
IP_INTERFACE_BRIDGE="192.168.0.103/24"
GATEWAY="192.168.1.1"
IP_PROMISCUOUS="0.0.0.0"

#Verificando se as dependêncais estão instaladas
echo -n "Verificando as dependências, aguarde... "
echo
for name in uml-utilities bridge-utils libpcap0.8 libpcap0.8-dev openjdk-11-jre
do
  [[ $(dpkg -s $name 2> /dev/null) ]] || { echo -en "\nO software: $name precisa ser instalado. \nUse o comando 'sudo apt-get install $name'\n";deps=1; }
done
[[ $deps -ne 1 ]] && echo "Dependências.: OK" || { echo -en "\nInstale as dependências acima e execute novamente este script\n";exit 1; }

echo -e "Inicializando o Módulo de Tunelamento, aguarde..."
	#Iniciando o módulo de tunelamento dos protocolos TUN/TAP
	sudo modprobe tun
echo -e "Módulo inicializado com sucesso!!!, continuando o script..."

echo -e "Criando a Inteface de Tunelamento: $INTERFACE_TUNTAP, aguarde..."
	#Criando a interface TUN/TAP
	sudo tunctl -t $INTERFACE_TUNTAP
echo -e "Interface de Tunelamento criada com sucesso!!!, continuando o script..."

echo -e "Criando a Inteface de Bridge: $INTERFACE_BRIDGE, aguarde..."
	#Criando a interface de Bridge
	sudo brctl addbr $INTERFACE_BRIDGE
echo -e "Interface de Bridge criada com sucesso!!!, continuando o script..."

echo -e "Configurando as Interface: $INTERFACE_LAN e $INTERFACE_TUNTAP em modo promíscuo, aguarde..."
	#Configurando as Interfaces de LAN e TUN/TAP para modo promíscuo
	sudo ifconfig $INTERFACE_LAN $IP_PROMISCUOUS promisc up   
	sudo ifconfig $INTERFACE_TUNTAP $IP_PROMISCUOUS promisc up
echo -e "Interfaces configuradas com sucesso!!!, continuando o script..."

echo -e "Adicionando as Interface: $INTERFACE_LAN e $INTERFACE_TUNTAP na Interface de: $INTERFACE_BRIDGE, aguarde..."
	#Adicionando as Interface $INTERFACE_LAN e $INTERFACE_TUNTAP ao grupo Bridge
	sudo brctl addif $INTERFACE_BRIDGE $INTERFACE_LAN   
	sudo brctl addif $INTERFACE_BRIDGE $INTERFACE_TUNTAP
echo -e "Interfaces adicionadas com sucesso!!!, continuando o script..."

echo -e "Inicializando a Interface de: $INTERFACE_BRIDGE, aguarde..."
	#Iniciando a Interfacce de Bridge
	sudo ifconfig $INTERFACE_BRIDGE up
echo -e "Interface inicializada com sucesso!!!, continuando o script"

echo -e "Configurando o Endereçamento IP da Interface: $INTERFACE_BRIDGE, aguarde..."
	#Obtendo as configurações de enderaçamento via DHCP
	#Caso queira configurar manualmente o enderaçamento IP
	#sudo ifconfig $INTERFACE_BRIDGE $IP_INTERFACE_BRIDGE
	#sudo route add default gw $GATEWAY
	sudo dhclient $INTERFACE_BRIDGE
echo -e "Endereçamento IP configurado com sucesso!!!, continuando o script..."

echo -e "Inicializando a conexão com Cisco Packet Tracer em Modo Bridge, aguarde..."
	#Inicializando o serviço de Bridge do Cisco Packet Tracer
	sudo java -jar ptbridge.jar $INTERFACE_BRIDGE $IP_PACKETTRACER:$PORT_PACKETTRACER $PASSWORD_PACETTRACE

#Removendo as configurações de Bridge e Tunelamento
#sudo ifconfig br0 down
#sudo ifconfig tap0 down
#sudo ifconfig eth0 down
#sudo brctl delbr br0
#sudo tunctl -d tap0
#sudo ifconfig eth0 up
#sudo dhclient eth0

echo -e "Conexão finalizada com sucesso!!!!"