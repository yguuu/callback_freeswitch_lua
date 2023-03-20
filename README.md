# callback_freeswitch_lua
Codigo OpenSource, para reduzir a tarifação 0800 no fusionpbx.
OpenSource code, to reduct 0800 billing in fusionpbx.


#Como usar:

Copie o script para dentro de "/usr/share/freeswitch/scripts".
Crie um destino para o numero 0800 com a ação "hangup" e na rota
de entrada criada para o respectivo destino adicione a ação final do tipo set
"api_hangup_hook=luarun callback_freeswitch.lua ${sip_from_user} "contexto" "destino" "nome" "gateway"
contexto = contexto utilizado no inquilino
destino = numero do ramal/fila/ivr em que o telefone sera destinado
nome = nome utilizado para identificar ligações vindas do callback
gateway = gateway que ira realizar as ligações para o callback

Lembrando que os parametros devem ser encaminhados sem as aspas.

#How to use:

Copy the script into "/usr/share/freeswitch/scripts".
Create a destination for the 0800 number with the "hangup" action and in the route
created input for the respective destination add the final action of type set
"api_hangup_hook=luarun callback_freeswitch.lua ${sip_from_user} "context" "destination" "name" "gateway"
context = context used in the tenant
destination = extension/callcenter/ivr number where the phone will be destined
name = name used to identify calls coming from the callback
gateway = gateway that will make calls to the callback

Remembering that the parameters must be forwarded without the quotes.