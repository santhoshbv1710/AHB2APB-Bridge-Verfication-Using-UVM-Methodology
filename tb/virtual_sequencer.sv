class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(virtual_sequencer)
	
	ahb_seqr hseqr;
	apb_seqr pseqr[];

	env_config cfg;
	
	
	function new(string name = "virtual_sequencer",uvm_component parent);
	super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config) :: get(this,"","env_config",cfg))
			`uvm_fatal("VR_SEQR","Getting Failed !!!")

		pseqr = new[cfg.no_of_agent];
		
	endfunction
	
endclass
