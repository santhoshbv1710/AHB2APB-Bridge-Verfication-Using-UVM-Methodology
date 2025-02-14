class env_config extends uvm_object;

`uvm_object_utils(env_config)

	bit has_hagent = 1;
	bit has_pagent = 1;
	bit has_virtual_sequencer = 1;
	bit has_scoreboard = 1;
	ahb_config ahb_cfg;
	apb_config apb_cfg[];


	int no_of_agent;
	int no_of_repeat;
	function new(string name = "env_config");
			super.new(name);
	endfunction
	
	function void build_phase(uvm_phase phase);
		apb_cfg = new[no_of_agent];
	endfunction
	
	
endclass
