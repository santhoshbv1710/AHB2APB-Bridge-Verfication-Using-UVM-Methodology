class apb_agent extends uvm_agent;

	`uvm_component_utils(apb_agent);

	function new(string name = "apb_agent",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	apb_driver pdrv;
	apb_monitor pmon;
	apb_seqr pseqr;
	apb_config conf;
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(apb_config) :: get(this,"","apb_config",conf))
			`uvm_fatal("APB_AGT","Getting Failed !!!")

		pmon = apb_monitor :: type_id :: create("pmon",this);
		
		if(conf.is_active == UVM_ACTIVE)begin
			pdrv = apb_driver :: type_id :: create("pdrv",this);
			pseqr= apb_seqr :: type_id :: create("pseqr",this);
		end
	endfunction

	function void connect_phase(uvm_phase phase);
		pdrv.seq_item_port.connect(pseqr.seq_item_export);
	endfunction

endclass

