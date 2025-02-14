class ahb_agent_top extends uvm_env;

	`uvm_component_utils(ahb_agent_top)

	function new(string name = "ahb_agent_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	ahb_agent hagt;

	function void build_phase(uvm_phase phase);

		hagt = ahb_agent :: type_id :: create("ahb_agent",this);
	endfunction

	
	 
endclass
