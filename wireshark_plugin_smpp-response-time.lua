
print "wireshark smpp response time lua plugin from gmd20"

local smpp_submit_sm_time_table = {}
local smpp_deliver_sm_time_table = {}

local frame_epochtime_f = Field.new("frame.time_epoch")
local smpp_seq_f = Field.new("smpp.sequence_number")
local smpp_cmd_id_f = Field.new("smpp.command_id")
-- declare our (pseudo) protocol
local smpp_time_proto = Proto("smpp_rsp_time","smpp response time")

local req_time_F = ProtoField.double("smpp_rsp_time.req_time","request time")
local rsp_time_F = ProtoField.double("smpp_rsp_time.time","response time")
-- add the field to the protocol
smpp_time_proto.fields = {req_time_F,rsp_time_F}

-- create a function to "postdissect" each frame
function smpp_time_proto.dissector(buffer,pinfo,tree)
  local cmd_id = {smpp_cmd_id_f()}
  local seq_id = {smpp_seq_f()}
  local epochtime = tonumber(tostring(frame_epochtime_f()))

  if #cmd_id ~= 0 and #seq_id == #cmd_id then
    for i, cmd_id_value in pairs(cmd_id) do
      local cmd_id_v =  tonumber(tostring(cmd_id_value))
      local seq_id_v =  tonumber(tostring(seq_id[i]))

      if cmd_id_v == 0x00000004 then
	smpp_submit_sm_time_table [seq_id_v] = epochtime
      elseif cmd_id_v == 0x80000004 then
        local req_time = smpp_submit_sm_time_table [seq_id_v]
        local duration = epochtime - req_time
        if duration >= 0 and duration < 10 then
          local subtree = tree:add(smpp_time_proto,"smpp response time")
          subtree:add(req_time_F,req_time)
          subtree:add(rsp_time_F,duration * 1000)
        end
      elseif cmd_id_v == 0x00000005 then
        smpp_deliver_sm_time_table [seq_id_v] = epochtime
      elseif cmd_id_v == 0x80000005 then
        local req_time = smpp_deliver_sm_time_table [seq_id_v]
        local duration = epochtime - req_time
        if duration >= 0 and duration < 10 then
          local subtree = tree:add(smpp_time_proto,"smpp response time")
          subtree:add(req_time_F,req_time)
          subtree:add(rsp_time_F,duration * 1000)
        end
      end      
    end
  end
end

-- register our protocol as a postdissector.
-- our dissector funtion get called on every packet
register_postdissector(smpp_time_proto)
