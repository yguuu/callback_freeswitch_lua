-- Global Variables

number = argv[1];
context = argv[2];
queue = argv[3];
name = argv[4];
gateway = argv[5];
limittime = 12;

--Stop Fuction

local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end
freeswitch.consoleLog("info","CALLBACK STARTING\n");
freeswitch.consoleLog("info","CALLBACK TARGET NUMBER: " ..number.. ".\n");
freeswitch.consoleLog("info","CALLBACK CALL GATEWAY: " ..gateway.. ".\n");
freeswitch.consoleLog("info","CALLBACK CONTEXT: " ..context.. " queue: " ..queue.. ".\n");

--Calling for the number

sleep(6);
freeswitch.consoleLog("notice","CALLBACK STARTING\n");
session = freeswitch.Session(gateway..number, session);
session:setAutoHangup(false);
session:setVariable("caller_id_name", name);

--Avoid crashing

counter = 0;
state=session:getState();
callstate=session:answered();
while (callstate == false and counter <= limittime) do
sleep(1);
state=session:getState();
callstate=session:answered();
session:consoleLog("debug","CALLBACK "..number.." CALL STATUS:"..state.."\n");
session:consoleLog("debug","CALLBACK "..number.."  NO RESPONSE \n");
counter = counter + 1;
end
if (counter >= limittime and callstate == false) then
session:consoleLog("err","CALLBACK "..number.." CALL LIMIT HIT\n");
freeswitch.consoleLog("info","CALLBACK "..number.." FINISHING.\n");
session:hangup("USER_BUSY");
session:destroy();
else

-- Transfer

session:execute("transfer", queue.." XML "..context);

--Indentifing call runing

state=session:getState();
while (state == "CS_SOFT_EXECUTE") do
sleep(2);
state=session:getState();
callstate=session:answered();
session:consoleLog("info","CALLBACK "..number.." CALL STATUS:"..state.."\n");
end
freeswitch.consoleLog("info","CALLBACK "..number.." FINISHING.\n");
session:destroy();
end
