function main()
	while true do
		monitor_router()
	end
end

function monitor_router()
	
	local reported
	local off_since
	--[[change the numbers on the following 2 lines to whatever outlet the router is plugged into ]]--
	
	local changes=event.change_listener(outlet[5])
	if not outlet[5].physical_state then
	  off_since=os.time() -- We don't know that for sure but that's when we start monitoring
	end
	for i,t,data in event.stream(changes,event.utc_time({sec=0})) do
		if i==2 then
			if off_since and t-off_since>60 then
			  --[[change this one as well]]--
			  ON(5)
			  if not reported then
				log.warning("Off for too long, since %s",os.date("%c",off_since))
				reported=true
			  end
			end
		elseif data.key=="physical_state" then
				if data.value==true then
				  off_since=nil
				  if reported then
					log.notice("On again, phew")
					reported=true
				  end
				elseif off_since==nil then
				  off_since=t
				end
			
		end   
	end
end

