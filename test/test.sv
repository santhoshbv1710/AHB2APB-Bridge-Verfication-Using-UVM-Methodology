class test extends uvm_test;
	`uvm_component_utils(test)
	
	env_config ecfg;
	env envh;
	
	ahb_config hcfg;
	
	apb_config pcfg[];
	virtual_sequence vseqs;
	int no_of_agent = 1;
	int has_hagent = 1;
	int has_pagent = 1;
	int count = 20;
	function new(string name = "test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		ecfg =  env_config :: type_id :: create("ecfg",this);
	
	if(has_hagent)begin
		hcfg = 	ahb_config :: type_id :: create("hcfg",this);		
		
		if(!uvm_config_db #(virtual ahb_if)::get(this,"","hvif",hcfg.vif))
				`uvm_fatal("TB_AHB","Getting failed !!!")
		ecfg.ahb_cfg = hcfg;
	end

	if(has_pagent)begin
		pcfg = new[no_of_agent];
		ecfg.no_of_agent = no_of_agent;
		ecfg.apb_cfg = new[no_of_agent];
		foreach(pcfg[i])begin
			pcfg[i] = apb_config :: type_id :: create($sformatf("pcfg[%0d]",i),this);
			if(!uvm_config_db #(virtual apb_if)::get(this,"","pvif",pcfg[i].vif))
				`uvm_fatal("TB_APB","Getting failed !!!")
			ecfg.apb_cfg[i] = pcfg[i];
		end
	end
		uvm_config_db #(env_config)::set(this,"*","env_config",ecfg);
	
		envh=env::type_id::create("envh", this);
	
	endfunction

	task run_phase(uvm_phase phase);
	uvm_top.print_topology;
	phase.raise_objection(this);
			vseqs=virtual_sequence::type_id::create("vseqs");

	phase.drop_objection(this);
	endtask
endclass

class single_test extends test;
	`uvm_component_utils(single_test)

	single_vseqs svseqs;

	function new(string name = "single_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		uvm_top.print_topology;

		phase.raise_objection(this);
			repeat(count)begin
		svseqs = single_vseqs :: type_id :: create("svseqs");
		svseqs.start(envh.vsqr);
			end
		#60;
		phase.drop_objection(this);
	endtask
endclass

class burst_test extends test;
	`uvm_component_utils(burst_test)

	burst_vseqs bvseqs;

	function new(string name = "burst_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		uvm_top.print_topology;
		phase.raise_objection(this);
		repeat(count)begin
		bvseqs = burst_vseqs :: type_id :: create("bvseqs");
		bvseqs.start(envh.vsqr);
		end
	#60;
		phase.drop_objection(this);
	endtask
endclass
