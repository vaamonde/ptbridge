# ptbridge

Esta ferramenta permite interligar o tráfego entre as redes do Cisco Packet Tracer e as redes reais. Por isso, traduz pacotes e mantém estados para a tradução do protocolo. Infelizmente, os pacotes e os protocolos do Cisco Packet Tracer são diferentes dos reais, o que dificulta sua tradução e inflexibilidade. Portanto, há apenas um punhado de protocolos implementados e estes podem ser instáveis.

Não é possível passar dados genéricos através de redes do Cisco Packet Tracer, como normalmente através de IP, TCP ou UDP.

## Suporte ao Protocolos

* Ethernet
* IP
* UDP
* TCP
* ARP
* ICMP
* DHCP (broken)
* Telnet

## Uso

Para usar esta ferramenta você precisa configurar um Linux VM no seu sistema operacional hospedeiro. Para isso eu usei o VirtualBox e Ubuntu e Linux Mint. 

Então você vai precisar de uma interface em ponte na VM para a rede que você deseja ptbridge estar conectado. 

No VM ptbridge precisa ser iniciado como root devido ao acesso de rede de baixo nível.

Então você precisa configurar o rastreador de pacotes para conexão multiusuário. Existem muitos tutoriais e
vídeos sobre isso na internet. 

A instância do rastreador de pacotes precisa estar no modo de servidor. Tente a conexão com uma segunda instância do tracer de pacotes. Depois disso, você pode conectar o ptbridge para rastreador de empacotador.

O uso desta ferramenta deve ser auto-explicativo:
`./ptbridge.jar <interface> <pt_ip>:<pt_port> <password>`
