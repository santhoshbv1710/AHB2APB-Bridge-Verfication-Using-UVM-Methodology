class ahb_agent extends uvm_agent;

	`uvm_component_utils(ahb_agent);

	function new(string name = "ahb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	ahb_driver hdrv;
	ahb_monitor hmon;
	ahb_seqr hseqr;
	
	ahb_config conf;
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(ahb_config) :: get(this,"","ahb_config",conf))
			`uvm_fatal("AHB_AGT","Getting Failed !!!")

		hmon = ahb_monitor :: type_id :: create("hmon",this);

		if(conf.is_active == UVM_ACTIVE)begin
			hdrv = ahb_driver :: type_id :: create("hdrv",this);
			hseqr= ahb_seqr :: type_id :: create("hseqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		hdrv.seq_item_port.connect(hseqr.seq_item_export);
	endfunction

endclass
