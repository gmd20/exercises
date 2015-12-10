--  Know issues:
--  This offical wireshark "tcap stat feature" can not identify the correct
--  tcap session (the tcap message matching is wrong, it seems the hash
--  function in packet_tcap.c has some problems.)
--
--  This script is base on tcap.otid and tcap.dtid only, the tcap message
--  matching may be wrong.,  if two tcap dailog between many DPCs use the
--  same transation_id.
--  The workaround is mannually split the capure files using filter like
--  "gsm_old.localValue == 45" or sccp.digits == "gt number", until each
--  capture file contains only one direction of 1 to 1 tcap messages,
--  that is to say no duplicate transation_id in one capture file.
--

print "wireshark tcap response time lua plugin from gmd20"
-- local original_m3ua_dissector
-- local original_sccp_dissector
local tcap_requests_time_table = {}

-- declare some Fields to be read
-- local frame_time_f = Field.new("frame.time")
-- local frame_len_f = Field.new("frame.len")
-- local frame_number_f = Field.new("frame.number")
local frame_epochtime_f = Field.new("frame.time_epoch")
local tcap_otid_f = Field.new("tcap.otid")
local tcap_dtid_f = Field.new("tcap.dtid")
-- declare our (pseudo) protocol
local tcap_time_proto = Proto("tcap_rsp_time","TCAP response time")
-- create the fields for our "protocol"
-- local req_time_F = ProtoField.string("tcap_rsp_time.req_time","request time")
-- local rsp_time_F = ProtoField.string("tcap_rsp_time.time","response time")
-- local req_frame_number_F = ProtoField.string("tcap_rsp_time.req_frame_number","request frame number")
local req_time_F = ProtoField.double("tcap_rsp_time.req_time","request time")
local rsp_time_F = ProtoField.double("tcap_rsp_time.time","response time")
-- add the field to the protocol
-- tcap_time_proto.fields = {req_frame_number_F,req_time_F,rsp_time_F}
tcap_time_proto.fields = {req_time_F,rsp_time_F}

-- create a function to "postdissect" each frame
function tcap_time_proto.dissector(buffer,pinfo,tree)
  -- we've replaced the original http dissector in the dissector table,
  -- but we still want the original to run, especially because we need to read its data
  -- original_m3ua_dissector:call(buffer, pinfo, tree)
  -- original_sccp_dissector:call(buffer, pinfo, tree)

  -- obtain the current values the protocol fields
  -- local otid = tcap_otid_f()
  -- local dtid = tcap_dtid_f()
  -- if 1 packet contains multiple tcap meesages,
  -- the return value is an array, see wireshark source code
  -- wireshark-1.12.1\epan\wslua\wslua_field.c
  local otid = {tcap_otid_f()}
  local dtid = {tcap_dtid_f()}
  local epochtime = tonumber(tostring(frame_epochtime_f()))

  if #otid ~= 0 then
    for i, otid_value in pairs(otid) do
      local otid_s = tostring(otid_value)
      tcap_requests_time_table[otid_s] = epochtime
    end

    -- local subtree = tree:add(tcap_time_proto,"TCAP response time")
    -- subtree:add(req_time_F, #otid)
    -- subtree:add(rsp_time_F, 0)
  elseif #dtid ~= 0 then
    for i, dtid_value in pairs(dtid) do
      local dtid_s = tostring(dtid_value)
      if tcap_requests_time_table[dtid_s] ~= nil then
        local req_time = tcap_requests_time_table[dtid_s];
        local duration = epochtime - req_time
        if duration >= 0 and duration < 10 then
          local subtree = tree:add(tcap_time_proto,"TCAP response time")
          -- local frame_number = frame_number_f()
          -- subtree:add(req_frame_number_F, tostring(frame_number))
          subtree:add(req_time_F,req_time)
          -- subtree:add(rsp_time_F,duration)
          subtree:add(rsp_time_F,duration * 1000) -- wireshark's "io graph"'s auto scale doesn't work
        end
      end
    end
  end
end

-- register our protocol as a postdissector.
-- our dissector funtion get called on every packet
register_postdissector(tcap_time_proto)

-- replace original m3ua dissector,
-- so our dissector function get called on every tcap message
-- local sctp_payload_dissector_table = DissectorTable.get("sctp.ppi")
-- original_m3ua_dissector = sctp_payload_dissector_table:get_dissector(3) -- save the original dissector so we can still get to it
-- sctp_payload_dissector_table:add(3, tcap_time_proto)                    -- and take its place in the dissector
-- local mtp3_service_indicator_dissector_table = DissectorTable.get("mtp3.service_indicator")
-- original_sccp_dissector = mtp3_service_indicator_dissector_table:get_dissector(3) -- save the original dissector so we can still get to it
-- mtp3_service_indicator_dissector_table:add(3, tcap_time_proto)                    -- and take its place in the dissector
