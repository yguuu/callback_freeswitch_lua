-- Variaveis Globais;

telefone = argv[1];
contexto = argv[2];
fila = argv[3];
tipo = argv[4];
gateway15 = argv[5];
gateway11 = argv[6];
tempolimite = 12;

-- Identificar tronco de saida

freeswitch.consoleLog("info","DDD: "..string.match(telefone, "^0%d%d", 1).." \n");

ddnumero = string.match(telefone, "^0%d%d");

if ddnumero == "015" then
gateway = gateway15;
else
gateway = gateway11;
end

--Função de pausa

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
freeswitch.consoleLog("info","CALLBACK INICIANDO\n");
freeswitch.consoleLog("info","CALLBACK NUMERO ALVO: " ..telefone.. ".\n");
freeswitch.consoleLog("info","CALLBACK GATEWAY DE LIGAÇÃO: " ..gateway.. ".\n");
freeswitch.consoleLog("info","CALLBACK CONTEXTO: " ..contexto.. " FILA: " ..fila.. ".\n");

--Ligando para o numero respectivo

sleep(6);
freeswitch.consoleLog("notice","CALLBACK INICIANDO\n");
session = freeswitch.Session(gateway..telefone, session);
session:setAutoHangup(false);
session:setVariable("caller_id_name", tipo);

--Evitando travamentos

contador = 0;
state=session:getState();
callstate=session:answered();
while (callstate == false and contador <= tempolimite) do
sleep(1);
state=session:getState();
callstate=session:answered();
session:consoleLog("debug","CALLBACK "..telefone.." STATUS DA LIGAÇÃO:"..state.."\n");
session:consoleLog("debug","CALLBACK "..telefone.."  NÃO ATENDIDO \n");
contador = contador + 1;
end
if (contador >= tempolimite and callstate == false) then
session:consoleLog("err","CALLBACK "..telefone.." TEMPO LIMITE ATINGIDO\n");
freeswitch.consoleLog("info","CALLBACK "..telefone.." FINALIZADO.\n");
session:hangup("USER_BUSY");
session:destroy();
else

-- Transferindo

session:execute("transfer", fila.." XML "..contexto);

--Identificar ligação em curso

state=session:getState();
while (state == "CS_SOFT_EXECUTE") do
sleep(2);
state=session:getState();
callstate=session:answered();
session:consoleLog("info","CALLBACK "..telefone.." STATUS DA LIGAÇÃO:"..state.."\n");
end
freeswitch.consoleLog("info","CALLBACK "..telefone.." FINALIZADO.\n");
session:destroy();
end
