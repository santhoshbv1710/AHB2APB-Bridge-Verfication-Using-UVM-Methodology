class env extends uvm_env;

	`uvm_component_utils(env);

	ahb_agent_top ahb_top;
	apb_agent_top apb_top;
	scoreboard sb;
	env_config conf;
	virtual_sequencer vsqr;
	function new(string name = "env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config) :: get(this,"","env_config",conf))
			`uvm_fatal("ENV","getting Failed !!!")

		if(conf.has_hagent)begin
			uvm_config_db #(ahb_config) :: set(this,"ahb_top*","ahb_config",conf.ahb_cfg);
			ahb_top = ahb_agent_top :: type_id :: create("ahb_top",this);
		end

		if(conf.has_pagent)begin
			foreach(conf.apb_cfg[i])
				uvm_config_db #(apb_config) :: set(this,$sformatf("apb_top.pagt[%0d]*",i),"apb_config",conf.apb_cfg[i]);
				apb_top = apb_agent_top :: type_id :: create("apb_top",this);
		end

		if(conf.has_virtual_sequencer)begin
				vsqr = virtual_sequencer :: type_id :: create("vsqr",this);
		end
		sb = scoreboard :: type_id :: create("sb",this);
	endfunction

	
	function void connect_phase(uvm_phase phase);

		if(conf.has_virtual_sequencer)begin
			 vsqr.hseqr = ahb_top.hagt.hseqr;
			
		foreach(apb_top.pagt[i])
				 vsqr.pseqr[i] = apb_top.pagt[i].pseqr;
					end

		begin
					ahb_top.hagt.hmon.monitor_port.connect(sb.hm.analysis_export);
					apb_top.pagt[0].pmon.monitor_port.connect(sb.pm[0].analysis_export);
		end
				
	endfunction

endclass
