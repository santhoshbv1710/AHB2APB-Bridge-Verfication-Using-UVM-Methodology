class apb_agent_top extends uvm_env;

	`uvm_component_utils(apb_agent_top)

	function new(string name = "apb_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	apb_agent pagt[];
	env_config conf;
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config) :: get(this,"","env_config",conf))
			`uvm_fatal("APB_AGT_TOP","Getting Failed !!!")

		pagt = new[conf.no_of_agent];

		foreach(pagt[i])
			pagt[i] = apb_agent :: type_id :: create($sformatf("pagt[%0d]",i),this);
	endfunction

	
	 
endclass

